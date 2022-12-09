import DirectedGraph

public extension DirectedGraph {
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
    @discardableResult
    func addTargetNode(labeled label: String) -> DirectedGraph.Node {
        return addUniqueNode(.target(labeled: label))
    }

    @discardableResult
    func addPackageProductNode(labeled label: String) -> DirectedGraph.Node {
        return addUniqueNode(.packageProduct(labeled: label))
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
    static func packageProduct(labeled label: String) -> DirectedGraph.Node {
        return Self(name: NodeName.packageProduct(label), label: label, shape: "box")
    }

    static func target(labeled label: String) -> DirectedGraph.Node {
        return Self(name: NodeName.target(label), label: label, shape: "hexagon")
    }
}

private enum ClusterName {
    static func project(_ string: String) -> String {
        return "cluster_project_" + string.safeName
    }

    static func package(_ string: String) -> String {
        return "cluster_package_" + string.safeName
    }
}

private enum NodeName {
    static func packageProduct(_ string: String) -> String {
        return "packageProduct_" + string.safeName
    }

    static func target(_ string: String) -> String {
        return "target_" + string.safeName
    }
}

