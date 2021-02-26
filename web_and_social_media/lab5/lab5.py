import os 
os.chdir("C:\\Users\\Zattri\\Desktop\\masters\\web_and_social_media\\lab5")

import networkx as nx
import matplotlib.pyplot as plt

# Undirected Graph
undirectG = nx.Graph()
undirectG.add_edge("1", "2")
undirectG.add_edge("1", "3")
undirectG.add_edge("1", "4")
undirectG.add_edge("2", "4")
undirectG.add_edge("2", "5")
undirectG.add_edge("3", "4")
undirectG.add_edge("4", "5")
undirectG.add_edge("6", "1")
undirectG.add_edge("6", "2")

nx.draw_networkx(undirectG)


# Directed graph
directedG = nx.DiGraph()
directedG.add_edge("1", "2")
directedG.add_edge("1", "3")
directedG.add_edge("1", "4")
directedG.add_edge("2", "4")
directedG.add_edge("3", "1")
directedG.add_edge("3", "2")
directedG.add_edge("4", "1")

nx.draw_networkx(directedG)

# Graph elements
print("Graph Nodes:", list(undirectG.nodes))
print("Graph Edges:", list(undirectG.edges))
print("Neighbours to Node 1:", list(undirectG.adj["1"]))
print("Degree of Node 1:", undirectG.degree["1"])

# Weighted graph
weightedG = nx.Graph()
weightedG.add_edge("Birmingham", "Wolverhampton", weight=17)
weightedG.add_edge("Birmingham", "Coventry", weight=22)
weightedG.add_edge("Wolverhampton", "Dudley", weight=6)
weightedG.add_edge("Birmingham", "Dudley", weight=9)

# Creating elements and colouring for the plot + labeling
pos = nx.spring_layout(weightedG)
plt.axis('off')
nx.draw_networkx_nodes(weightedG, pos, node_color="g", alpha=0.8)
nx.draw_networkx_edges(weightedG, pos, edge_color="b", alpha=0.6)
nx.draw_networkx_edge_labels(weightedG, pos, edge_labels = nx.get_edge_attributes(weightedG, "weight"))
nx.draw_networkx_labels(weightedG, pos)

# Calculating network paths using the weight attribute of each node
print(nx.shortest_path(weightedG, "Birmingham", "Wolverhampton", "weight"))
print(nx.shortest_path(weightedG, "Coventry", "Wolverhampton", "weight"))
print(nx.shortest_path_length(weightedG, "Coventry", "Wolverhampton", "weight"))

# Eccentricity - Max distance from a node to all other nodes in the graph
nx.eccentricity(weightedG, v="Wolverhampton")

# Degree centrality - How much of the network is connected by each node
nx.degree_centrality(weightedG)
nx.eigenvector_centrality(weightedG)
nx.betweenness_centrality(weightedG)

# Loading Facebook user node data
fb_g = nx.read_edgelist("facebook_combined.txt", create_using=nx.Graph(), nodetype=int)
print(nx.info(fb_g))
pos = nx.spring_layout(fb_g)
node_color = [20000 * fb_g.degree(v) for v in fb_g]
plt.figure(figsize=(20, 20))

# Using different centrality measures to analyse nodes
betCent = nx.betweenness_centrality(fb_g, normalized=True, endpoints=True)
degCent = nx.degree_centrality(fb_g)
eigenCent = nx.eigenvector_centrality(fb_g)

node_size = [v * 10000 for v in betCent.values()]
node_size = [v * 10000 for v in degCent.values()]
node_size = [v * 10000 for v in eigenCent.values()]

nx.draw_networkx(fb_g, pos=pos, with_labels=False, node_color=node_color, node_size=node_size)
plt.axis("off")





