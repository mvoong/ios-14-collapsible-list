import UIKit

class ViewController: UICollectionViewController {

    private enum Item: Hashable {
        case header(String)
        case row(String)
    }

    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item
            cell.contentConfiguration = configuration
            cell.accessories = [.outlineDisclosure(options: UICellAccessory.OutlineDisclosureOptions(style: .header))]
        }

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item
            configuration.secondaryText = "Secondary"
            cell.contentConfiguration = configuration
            cell.accessories = [.multiselect(displayed: .always)]
        }

        switch item {
        case .header(let string):
            return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: string)
        case .row(let string):
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: string)
        }
    })

    init() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .firstItemInSection

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Collapsable List"

        collectionView.dataSource = dataSource
        collectionView.allowsMultipleSelection = true

        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let header = Item.header("Section")
        sectionSnapshot.append([header])
        sectionSnapshot.append([.row("Test"), .row("Test 2"), .row("Test 3")], to: header)
        sectionSnapshot.expand([header])

        dataSource.apply(sectionSnapshot, to: 0, animatingDifferences: false)
    }
}

