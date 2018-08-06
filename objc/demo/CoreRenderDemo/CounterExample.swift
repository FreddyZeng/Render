import UIKit
import CoreRender

// MARK: - ViewController

class CounterViewController: UIViewController {
  private var node: ConcreteNode<UIView>?
  private let context = Context()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    render()
  }

  func render() {
    node = counterNode()
    node?.registerHierarchy(in: context)
    node?.reconcile(in: view, constrainedTo: view.bounds.size, with: [])
  }

  override func viewDidLayoutSubviews() {
    render()
  }
}

// MARK: - Node

func counterNode() -> ConcreteNode<UIView> {
  let node = Node(type: UIView.self, controller: CounterController.self, key: "counter") { spec in
    set(spec, keyPath: \UIView.yoga.width, value: spec.size.width)
  }
  let wrapper = Node(type: UIView.self) { spec in
    set(spec, keyPath: \UIView.backgroundColor, value: .lightGray)
    set(spec, keyPath: \UIView.cornerRadius, value: 5)
    set(spec, keyPath: \UIView.yoga.margin, value: 20)
    set(spec, keyPath: \UIView.yoga.padding, value: 20)
  }
  let label = Node(type: UIButton.self) { spec in
    guard
      let state = spec.state as? CounterState,
      let controller = spec.controller as? CounterController else { return }
    spec.view?.setTitle("Count: \(state.count)", for: .normal)
    spec.view?.addTarget(
      controller,
      action: #selector(CounterController.incrementCounter),
      for: .touchUpInside)
  }
  node.append(children: [wrapper])
  wrapper.append(children: [label])

  return node
}

// MARK: - State

class CounterState: State {
  var count = 0;
}

// MARK: - Controller

class CounterController: Controller<NullProps, CounterState> {


  @objc dynamic func incrementCounter() {
    self.state.count += 1
  }

}


