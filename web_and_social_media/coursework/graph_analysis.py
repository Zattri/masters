import os
import os.path 
import networkx as nx
from cdlib import algorithms, viz
import pandas as pd

curr_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(curr_dir)


nodes = nx.read_edgelist("public_figure_edges.csv", create_using=nx.Graph(),
                            nodetype=int, delimiter = ",")

min_degree = 100

f = nx.Graph()
fedges = filter(lambda x: nodes.degree()[x[0]] > min_degree and nodes.degree()[x[1]] > min_degree, nodes.edges())
f.add_edges_from(fedges)


comms = algorithms.louvain(f, weight="weight", resolution=1.)
pos = nx.spring_layout(f)


nx.degree_centrality(f)
nx.eigenvector_centrality(f)
nx.betweenness_centrality(f)


betCent = nx.betweenness_centrality(f, normalized=True, endpoints=True)
#degCent = nx.degree_centrality(f)
#eigenCent = nx.eigenvector_centrality(f)

node_color = [20000 * f.degree(v) for v in f]

node_size = [v * 10000 for v in betCent.values()]
#node_size = [v * 10000 for v in degCent.values()]
#node_size = [v * 10000 for v in eigenCent.values()]

nx.draw_networkx(f, pos=pos, with_labels=False, node_color=node_color, node_size=node_size)

viz.plot_network_clusters(f, comms, pos)
viz.plot_community_graph(f, comms)

#print(len(comms.communities))
#print(comms.communities[0])