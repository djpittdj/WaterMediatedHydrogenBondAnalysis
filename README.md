# WaterMediatedHydrogenBondAnalysis
Analyze hydrogen bonding network that is mediated by a water molecule in a molecular dynamics simulation
[![hbond_network](https://cloud.githubusercontent.com/assets/7023606/9009943/4a7ad8a4-3772-11e5-8ca0-74b678a63cd0.png)](#features)
This is a more complicated analysis compared to the hydrogen bonding network analysis involving only the protein residues.
The water molecules and protein residues can both act as donors or acceptors, in order to find the water mediated hydrogen bond across two protein domains, e.g., D1 and D2, four pairs of interactions have to be considered for each frame of the simulation:
donor   acceptor
water   D1
D1      water
water   D2
D2      water

We are looking for a pattern like this: D1 protein residue -- water -- D2 protein residue.
Every pair of hydrogen bonds in a frame has to be compared with all the other pairs in the same frame to see if these two pairs of hydrogen bonds share the same water molecule, and also has one protein residue on D1 and another on D2.
After we find out which D1/D2 residue pairs are involved in hydrogen bond, we go over the trajectory again to find out the frequency of formation for each pair.
