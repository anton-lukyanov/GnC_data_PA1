library("data.table")
#Dates we are looking for
firstDate<-as.Date("2007-02-01")
lastDate<-as.Date("2007-02-02")

#1.instead of reading all data, find exact part of the file containg specific period


#read only 1st row
firstRow<-fread("household_power_consumption.txt",sep=";",header=TRUE,nrow=1) 

#get date
earliestDate<-as.Date(firstRow$Date[1],"%d/%m/%Y")

#count number of columns
nc <- ncol(firstRow)

#create one-column table with dates to find specific period
Dates <- fread("household_power_consumption.txt",sep=";",header=TRUE, 
               colClasses = c(NA, rep("NULL", nc - 1)))                         
Dates$Date<-as.Date(Dates$Date,"%d/%m/%Y")

#starting row
rowsToSkip<-which.max(Dates$Date >= firstDate)-1                        

#count number of rows to read
rowsToRead<-nrow(Dates[Dates$Date %in% c(firstDate,lastDate),])         

#read exatly two days from file
d<-fread("household_power_consumption.txt",sep=";",header=FALSE,
         skip=rowsToSkip+1,nrows=rowsToRead, colClasses=c(rep("character",2),
         rep("numeric",7)),na.string=c("NA","?",""))

#as we skip headers in fread() add colnames from firstRow
setnames(d,names(d),names(firstRow))


#2. Create plot and copy to graphic device

#empty plot with data w/o x-axis ticks
plot(d$Global_active_power, type="n",xlab="",main="",
     ylab="Global Active Power (kilowatts)",xaxt='n')

#add lines
lines(d$Global_active_power)

#add x-axis with weekdays
axis(side=1,at=c(1,nrow(d)*0.5,nrow(d)),labels=c("Thu","Fri","Sat")) 

dev.copy(png, file = "plot2.png")
dev.off() 
