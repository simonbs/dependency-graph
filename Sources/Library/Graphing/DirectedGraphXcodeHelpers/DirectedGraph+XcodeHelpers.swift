import DirectedGraph

public extension DirectedGraph {
    func packageNode(labeled label: String) -> DirectedGraph.Node? {
        return node(named: NodeName.package(label))
    }

    func packageProductNode(labeled label: String) -> DirectedGraph.Node? {
        return node(named: NodeName.packageProduct(label))
    }

    func targetNode(labeled label: String) -> DirectedGraph.Node? {
        return node(named: NodeName.target(label))
    }

    @discardableResult
    func addProjectCluster(labeled label: String) -> DirectedGraph.Cluster {
        return addUniqueCluster(.project(labeled: label))
    }

    @discardableResult
    func addPackageCluster(labeled label: String) -> DirectedGraph.Cluster {
        return addUniqueCluster(.package(labeled: label))
    }
}

public extension DirectedGraph.Cluster {
    static func project(labeled label: String, nodes: [DirectedGraph.Node] = []) -> DirectedGraph.Cluster {
        return Self(name: ClusterName.project(label), label: label, nodes: nodes)
    }

    static func package(labeled label: String, nodes: [DirectedGraph.Node] = []) -> DirectedGraph.Cluster {
        return Self(name: ClusterName.package(label), label: label, nodes: nodes)
    }
}

public extension DirectedGraph.Node {
    static func project(labeled label: String) -> DirectedGraph.Node {
        return Self(name: NodeName.project(label), label: label, shape: .ellipse)
    }

    static func package(labeled label: String) -> DirectedGraph.Node {
        return Self(name: NodeName.package(label), label: label, shape: .ellipse)
    }

    static func packageProduct(labeled label: String) -> DirectedGraph.Node {
        return Self(name: NodeName.packageProduct(label), label: label, shape: .ellipse)
    }

    static func target(labeled label: String) -> DirectedGraph.Node {
        return Self(name: NodeName.target(label), label: label, shape: .box)
    }
}

private enum ClusterName {
    static func project(_ string: String) -> String {
        return "project_" + string.safeName
    }

    static func package(_ string: String) -> String {
        return "package_" + string.safeName
    }
}

private enum NodeName {
    static func project(_ string: String) -> String {
        return "project_" + string.safeName
    }

    static func package(_ string: String) -> String {
        return "package_" + string.safeName
    }

    static func packageProduct(_ string: String) -> String {
        return "packageProduct_" + string.safeName
    }

    static func target(_ string: String) -> String {
        return "target_" + string.safeName
    }
}
