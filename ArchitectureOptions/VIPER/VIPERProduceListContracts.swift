//
//  VIPERProduceListContracts.swift
//  ArchitectureOptions
//
//  Protocols describing how the VIPER layers talk to each other.
//

extension VIPER {
    enum SortOrder {
        case ascending
        case descending

        var toggled: SortOrder {
            self == .ascending ? .descending : .ascending
        }
    }

    enum ProduceFilter: CaseIterable, Identifiable {
        case fruit
        case vegetables
        case all

        var id: Self { self }

        var title: String {
            switch self {
            case .fruit: "Fruit"
            case .vegetables: "Vegetables"
            case .all: "All"
            }
        }
    }

    /// View -> Presenter
    protocol ProduceListPresenterInput: AnyObject {
        func viewDidLoad()
        func didTapSort()
        func didSelectFilter(_ filter: ProduceFilter)
    }

    /// Presenter -> Interactor
    protocol ProduceListInteractorInput: AnyObject {
        func loadProduce(sortedBy order: SortOrder, filteredBy filter: ProduceFilter)
    }

    /// Interactor -> Presenter
    protocol ProduceListInteractorOutput: AnyObject {
        func didLoadProduce(_ produce: [Produce])
    }

    /// Entity data source used by the Interactor
    protocol ProduceDataSource {
        func allProduce() -> [Produce]
    }
}
