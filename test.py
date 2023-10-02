# import re

# pattern = r"<<([a-zA-Z0-9]*)>>"
# pattern_use = r"\[\[([a-zA-Z0-9]*)\]\[.*?\]\]"

# sllj = open('/home/shore/OneDrive/数理逻辑/sllj_back.org', 'r')
# lssx = open('/home/shore/OneDrive/离散数学/Disc_Math.org', 'r')

# sllj_text = sllj.read()
# lssx_text = lssx.read()
 
# sllj_map = {}
# lssx_map = {}

# i = 1
# with open('mark_map_lssx.txt', 'w') as f:
#     for match in re.finditer(pattern, lssx_text):
#         lssx_map[match.group(1)] = "MK" + str(i)
#         print(match.group(0) + " | " + lssx_map[match.group(1)], file=f)
#         i += 1

# i = 1
# with open('mark_map_sllj.txt', 'w') as f:
#     for match in re.finditer(pattern, sllj_text):
#         sllj_map[match.group(1)] = "MK" + str(i)
#         print(match.group(0) + " | " + sllj_map[match.group(1)], file=f)
#         i += 1

# for match in sllj_map:
#     if match in lssx_map:
#         print("double mark set: " + match)

# for match in lssx_map:
#     if match in sllj_map:
#         print("double mark set: " + match)


# # for each in sllj_map:
# #     print(each + " " + sllj_map[each])
# # print("====================================")
# # for each in lssx_map:
# #     print(each + " " + lssx_map[each])

# with open('log_lssx.txt', 'w') as f:
#     for match in re.finditer(pattern_use, lssx_text):
#         if match.group(1) in lssx_map:
#             print(lssx_text[match.regs[0][0]:match.regs[0][1]] + " | " + lssx_text[match.regs[1][0]:match.regs[1][1]] + " | " + lssx_map[match.group(1)], file=f)
#         elif match.group(1) in sllj_map:
#             print(lssx_text[match.regs[0][0]:match.regs[0][1]] + " | " + lssx_text[match.regs[1][0]:match.regs[1][1]] + " | " + "~/OneDrive/数理逻辑/sllj.org::" + sllj_map[match.group(1)], file=f)
#         else:
#             print(lssx_text[match.regs[0][0]:match.regs[0][1]] + " | " + lssx_text[match.regs[1][0]:match.regs[1][1]] + " | " + "not found")
#             exit(1)

# with open('log_sllj.txt', 'w') as f:
#     for match in re.finditer(pattern_use, sllj_text):
#         if match.group(1) in sllj_map:
#             print(sllj_text[match.regs[0][0]:match.regs[0][1]] + " | " + sllj_text[match.regs[1][0]:match.regs[1][1]] + " | " + sllj_map[match.group(1)], file=f)
#         elif match.group(1) in lssx_map:
#             print(sllj_text[match.regs[0][0]:match.regs[0][1]] + " | " + sllj_text[match.regs[1][0]:match.regs[1][1]] + " | " + "~/OneDrive/离散数学/Disc_Math.org::" + lssx_map[match.group(1)], file=f)
#         else:
#             print(sllj_text[match.regs[0][0]:match.regs[0][1]] + " | " + sllj_text[match.regs[1][0]:match.regs[1][1]] + " | " + "not found")
#             exit(1)

# # Create new strings for modified text
# sllj_text_rep_mark = ""
# lssx_text_rep_mark = ""

# # Replace marks
# start = 0
# for match in re.finditer(pattern, lssx_text):
#     lssx_text_rep_mark += lssx_text[start:match.regs[1][0]]
#     lssx_text_rep_mark += lssx_map[match.group(1)]
#     start = match.regs[1][1]
# lssx_text_rep_mark += lssx_text[start:]

# # Replace marks
# start = 0
# for match in re.finditer(pattern, sllj_text):
#     sllj_text_rep_mark += sllj_text[start:match.regs[1][0]]
#     sllj_text_rep_mark += sllj_map[match.group(1)]
#     start = match.regs[1][1]
# sllj_text_rep_mark += sllj_text[start:]

# sllj_text_rep_link = ""
# lssx_text_rep_link = ""

# # replace links
# start = 0
# for match in re.finditer(pattern_use, lssx_text_rep_mark):
#     lssx_text_rep_link += lssx_text_rep_mark[start:match.regs[1][0]]
#     if match.group(1) in lssx_map:
#         lssx_text_rep_link += lssx_map[match.group(1)]
#     elif match.group(1) in sllj_map:
#         lssx_text_rep_link += "~/OneDrive/数理逻辑/sllj.org::" + sllj_map[match.group(1)]
#     else:
#         print("not found")
#         exit(1)
#     start = match.regs[1][1]
# lssx_text_rep_link += lssx_text_rep_mark[start:]

# # replace links
# start = 0
# for match in re.finditer(pattern_use, sllj_text_rep_mark):
#     sllj_text_rep_link += sllj_text_rep_mark[start:match.regs[1][0]]
#     if match.group(1) in sllj_map:
#         sllj_text_rep_link += sllj_map[match.group(1)]
#     elif match.group(1) in lssx_map:
#         sllj_text_rep_link += "~/OneDrive/离散数学/lssx.org::" + lssx_map[match.group(1)]
#     else:
#         print("not found")
#         exit(1)
#     start = match.regs[1][1]
# sllj_text_rep_link += sllj_text_rep_mark[start:]

# # Write the new text to files
# f_1 = open('sllj.org', 'w')
# f_2 = open('lssx.org', 'w')

# f_1.write(sllj_text_rep_link)
# f_2.write(lssx_text_rep_link)

k = 32
 
for i in range(1, k):
    print(str(i) +":" ,(i+2)/(k/2) - (2*i-1)/((int)(k/i)*i))