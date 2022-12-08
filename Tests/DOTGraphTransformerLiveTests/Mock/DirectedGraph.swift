import DirectedGraph

extension DirectedGraph {
    static var mock: DirectedGraph {
        let fooNode = DirectedGraph.Node(name: "Foo", label: "Foo")
        let fooCluster = DirectedGraph.Cluster(name: "Foo", label: "Foo", nodes: [fooNode])
        let barNode = DirectedGraph.Node(name: "Bar", label: "Bar")
        let barCluster = DirectedGraph.Cluster(name: "Bar", label: "Bar", nodes: [barNode])
        let bazNode = DirectedGraph.Node(name: "Baz", label: "Baz")
        let bazCluster = DirectedGraph.Cluster(name: "Baz", label: "Baz", nodes: [bazNode])
        return DirectedGraph(clusters: [
            fooCluster,
            barCluster,
            bazCluster
        ], edges: [
            DirectedGraph.Edge(from: fooNode, to: barNode),
            DirectedGraph.Edge(from: fooNode, to: bazNode)
        ])
    }
}
