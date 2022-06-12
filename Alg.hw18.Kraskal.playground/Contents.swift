typealias Vertex = String
typealias Edge = (from: Vertex, to: Vertex, cost: Int)
typealias Graph = [Vertex: [Vertex: Int]]

var graph = Graph()

graph["A"] = ["B": 20, "C": 12, "D": 9, "F": 3]
graph["B"] = ["A": 20, "C": 8, "E": 4, "H": 10]
graph["C"] = ["A": 12, "B": 8, "D": 7, "E": 2]
graph["D"] = ["A": 9, "C": 7, "F": 7, "D": 3]
graph["E"] = ["B": 4, "C": 2, "G": 9, "H": 6]
graph["F"] = ["A": 3, "D": 7, "G": 2, "K": 10]
graph["G"] = ["D": 3, "E": 9, "F": 2, "H": 8, "K": 5]
graph["H"] = ["B": 10, "E": 6, "H": 8, "K": 4]
graph["K"] = ["F": 10, "H": 4, "G": 5]

var resultGraph = Graph()
var edges = getEdges(from: graph)

while !edges.isEmpty {
    let minEdge = edges.removeLast()

    guard !isPathFromEdgeVertexes(minEdge, graph: resultGraph) else { continue }

    resultGraph = add(edge: minEdge, to: resultGraph)
}

print(resultGraph)

/// Возвращает отсортированный по стоимости массив ребер графа
func getEdges(from graph: Graph) -> [Edge] {
    var edges = [Edge]()
    for (vertex, siblings) in graph {
        for (siblingVertex, cost) in siblings {
            edges.append(Edge(vertex, siblingVertex, cost))
        }
    }
    edges.sort { a, b in
        a.cost > b.cost
    }
    return edges
}

/// Проверяет существует ли путь в графе от одного конца ребра до другого
func isPathFromEdgeVertexes(_ edge: Edge, graph: Graph) -> Bool {
    guard let _ = resultGraph[edge.from] else { return false }
    guard let _ = resultGraph[edge.to] else { return false }
    return bfs(graph: graph, from: edge.from, to: edge.to)
}

/// ВFS пути из одной вершины в другую
func bfs(graph: Graph, from: Vertex, to: Vertex) -> Bool {
    var queue = [from]
    var checked = Set<Vertex>()
    while !queue.isEmpty {
        let vertex = queue.removeFirst()
        guard !checked.contains(vertex) else { continue }
        if vertex == to {
            return true
        }
        checked.insert(vertex)
        guard let children = graph[vertex] else { continue }
        children.forEach { queue.append($0.key) }
    }
    return false
}

/// Добавляет новое ребро в граф
func add(edge: Edge, to graph: Graph) -> Graph {
    var graph = graph

    var siblings = [String: Int]()
    if let siblingsExist = graph[edge.from] {
        siblings = siblingsExist
    }
    siblings[edge.to] = edge.cost
    graph[edge.from] = siblings

    siblings = [String: Int]()
    if let siblingsExist = graph[edge.to] {
        siblings = siblingsExist
    }
    siblings[edge.from] = edge.cost
    graph[edge.to] = siblings

    return graph
}
