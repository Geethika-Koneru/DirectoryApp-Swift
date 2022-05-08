//
//  MeetingListViewController.swift
//  DirectoryApp
//
//  Created by Geethika on 08/05/22.
//
import UIKit
import Foundation

// MARK: - Model
/// Room Model
struct Room: Codable {
    let createdAt: String
    let isOccupied: Bool
    let maxOccupancy: Int
    let id: String
}

typealias Rooms = [Room]

// MARK: - View Model
struct RoomsListViewModel {
    
    var rooms: Observable<[MeetingTableViewCellViewModel]> = Observable([])
    let offline = true
    
    enum RoomConstants {
        fileprivate static let JsonName = "RoomsData"
        fileprivate static let urlString = "https://61e947967bc0550017bc61bf.mockapi.io/api/v1/rooms"
    }
    
    /// Fetch people data from url
    fileprivate func parseRoomData(_ data: Data) throws {
        do {
            let colleagueModels = try JSONDecoder().decode(Rooms.self, from: data)
            self.rooms.value = colleagueModels.compactMap({ MeetingTableViewCellViewModel(model: $0)
            })
        }
    }
    
    fileprivate func fetchMeetingRooms(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        NetworkHandler.getData(url: url, completion: { data, _, _ in 
            guard let data = data else { return }
            do {
                try parseRoomData(data)
            } catch {
                debugPrint("Colleague data parsing failed")
            }
        })
    }

    
    /// Fetch data from either API or JSON based on the temp variable offline
    func fetchData() throws {
        if offline {
            do {
                if let jsonData = try NetworkHandler.readData(from: RoomConstants.JsonName, fileExtension: "json") {
                    try parseRoomData(jsonData)
                }
            }
        } else {
            fetchMeetingRooms(from: RoomConstants.urlString)
        }
    }
}

struct MeetingTableViewCellViewModel {
    let room: Room

    init(model: Room) {
        room = model
    }
}

// MARK: - View Controller
class MeetingListViewController: UIViewController {
    // MARK: - Properties
    private let reuseIdentifier = "Cell"
    private var viewModel = RoomsListViewModel()
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        do {
            try viewModel.fetchData()
        } catch let error {
            debugPrint("Failed to get rooms data with error: \(error)")
        }
    }
    
    fileprivate func bindViewModelData() {
        viewModel.rooms.bind { rooms in
            self.collectionView.reloadData()
        }
    }
}

extension MeetingListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rooms.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? MeetingCollectionViewCell
        cell?.viewModel = viewModel.rooms.value?[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - Collection View Flow Layout Delegate
extension MeetingListViewController: UICollectionViewDelegateFlowLayout {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
            self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
        else {
            return
        }

        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
        coordinator.animate(alongsideTransition: { _ in
            
        }, completion: { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
