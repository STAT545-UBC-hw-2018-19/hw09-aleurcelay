words <- readLines("./Data/words.txt")
words_lower <-tolower(words) #avoid letter repetition due to capitalization

#compute letter frequency
letters_freq<-table(factor(unlist(strsplit(words_lower, ""), use.names=FALSE), levels=letters))
letters_freq <- as.data.frame(letters_freq) #convert to data frame to plot
colnames(letters_freq) <- c("letter", "frequency")
as.factor(letters_freq$letter)

#write tsv
write.table(letters_freq, "letters_freq.tsv",
					sep = "\t", row.names = FALSE, quote = FALSE)
