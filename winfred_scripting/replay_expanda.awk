
# add trim function to 'expand', and also 'contract' a column for best fit column size
# for trimming sqlplus output and remove spaces from long fields
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

BEGIN {
	# assume FS is passed in, or defaulted to " ". (awk's default behaviour for FS=" " may not be what you want, chk awk manual pls)
	#print FS
	nfield = 0
}

{
	for (i=1; i <=NF; i++) {
		if (NR == 1) { fieldlength[i] = 1 }
		
		field=trim($i)
		# print field
		# print length(field)
		if (fieldlength[i] < length(field))
			fieldlength[i] = length(field)
	}

	if (NF > nfield) {
		nfield = NF
	}

	lines[NR] = $0
	#print lines[NR]
}

END {
	#for (i=1; i<=nfield; i++) {
	#	print fieldlength[i]
	#}

	for (j=1; j <=NR; j++) {
		split(lines[j], fields, FS)
		for (i=1; i <=nfield && i <= length(fields); i++) {
		#for (i=1; i <=nfield; i++) {
		#	if (i > length(fields))
		#		break

			field=trim(fields[i])

			# print i ":" field
			if (i==1)
				line = sprintf("%-*s", fieldlength[i], field)
			else
				line = line FS sprintf("%-*s", fieldlength[i], field)
		}
		print line
	}
}
