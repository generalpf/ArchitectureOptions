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

    /// View -> Presenter
    protocol ProduceListPresenterInput: AnyObject {
        func viewDidLoad()
        func didTapSort()
    }

    /// Presenter -> Interactor
    protocol ProduceListInteractorInput: AnyObject {
        func loadProduce(sortedBy order: SortOrder)
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
