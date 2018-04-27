# bond-orientational-order

Author: Ali Hashmi

An analysis performed for a team studying opto/acousto-microfluidics. The experimenters were interested in detecting and following defects emerging in the local crystaline order over time.

**Strategy** : The image is first segmented to get the centres of the beads and any discrepancies are manually corrected. The centres are used to generate a Delaunay Mesh. The adjoining neighbours of all the cells are determined from the mesh. The angles subtended between a cell and its neighbours - with respect to a reference axis - yields the bond orientational order. The orientational order is the colormap to the Voronoi Mesh. 

Code to come soon ...


Below is one such analysis: 

![alt text](https://github.com/alihashmiii/bond-orientational-order/blob/master/for%20ReadMe/bond-orientational-order.png)
