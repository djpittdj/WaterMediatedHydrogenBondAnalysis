#!/usr/bin/python
import operator, re, os

cutoff = 3.0

D1_resid = range(1,139)
D1_resid += range(247, 282)
D1_resid += [290]

D2_resid = range(143, 244)

start_water_resid = 291

raw = []
hbonds = set()
total_num_frames = 0
for line in open("hbonds_res-D1lig-wat-D2_cut%s.xvg" % cutoff):
	line_split = line.split()
	frame = int(line_split[0])
	total_num = int(line_split[1])
	total_num_frames += 1
	if frame % 10 == 0:
		print frame

	if total_num == 0:
		continue
	else:
		matched_all = re.findall(r'(\{(\d*) (\d*)\})', line, re.M|re.I)
		water_residue_pairs = set()
		for i in xrange(0, len(matched_all)):
			donor_resid = int(matched_all[i][1])
			acceptor_resid = int(matched_all[i][2])
			
			# water is donor
			if donor_resid >= start_water_resid:
				hb = (donor_resid, acceptor_resid)
			# water is acceptor
			elif acceptor_resid >= start_water_resid:
				hb = (acceptor_resid, donor_resid)

			water_residue_pairs.add(hb)

	hb_one_frame = []
	lst = list(water_residue_pairs)
	for i in range(0, len(lst)):
		water_resid1 = lst[i][0]
		prot_resid1 = lst[i][1]
		for j in range(0, len(lst)):
			if j > i:
				water_resid2 = lst[j][0]
				prot_resid2 = lst[j][1]
				if water_resid1 == water_resid2:
					if prot_resid1 in D1_resid and prot_resid2 in D2_resid:
						hb = (prot_resid1, prot_resid2)
						hbonds.add(hb)
						hb_one_frame.append(hb)
					elif prot_resid2 in D1_resid and prot_resid1 in D2_resid:
						hb = (prot_resid2, prot_resid1)
						hbonds.add(hb)
						hb_one_frame.append(hb)

	one_frame = [frame, hb_one_frame]
	raw.append(one_frame)

dic = {}
for hb in hbonds:
	dic[hb] = 0

for one_frame in raw:
	hb_one_frame = one_frame[1]
	for hb in hbonds:
		if hb in hb_one_frame:
			dic[hb] += 1

lst_dic_sort = sorted(dic.iteritems(), key=operator.itemgetter(1), reverse=True)
outfile = open("hb_counts_res_D1lig-wat-D2_cut%s.xvg" % cutoff, 'w')
for one_hb in lst_dic_sort:
	hb = one_hb[0]
	num_hb = int(one_hb[1])
	print>>outfile, "%-25s\t%8i%8.3f" % (str(hb[0])+str(" ")+str(hb[1]), num_hb, float(num_hb)/total_num_frames)
outfile.close()
