# Custom Makefile for Compiling Research Diaries
# ----------------------------------------------
#
#  Author:   Mikhail Klassen
#  Email:    klassm@mcmaster.ca
#  Created:  21 November 2011
#  Modified: 06 October 2019
ADDENTRY_SCRIPT := src/add_entry.sh

# Set the diary year you wish to compile and user info
# year=`date +%G`
# month=`date +%m`
# day=`date +%d`
# AUTHOR := FirstName LastName
# INSTITUTION := InstitutionName
#
# the different timestamps
YEARTD := $(shell date +%G)
MONTHTD := $(shell date +%m)
DAYTD := $(shell date +%d)

# TEXFILE=$year-$month-$day.tex
# PSFILE=$year-$month-$day.ps
# DVIFILE=$year-$month-$day.dvi
# PDFFILE=$year-$month-$day.pdf
#
# Do not edit past this line
RM := rm -rf
SHELL := /bin/bash
#
DATE := $(YEARTD)-$(MONTHTD)-$(DAYTD)
FILE := main
OUT  := build
# export TEXINPUTS := ./src/:$(TEXINPUTS)
export TEXINPUTS := ./include/:$(TEXINPUTS)
# OUTTD  := $(YEARTD)

# TEXFILE := $(YEARTD)/$(DATE).tex
FILETD := $(YEARTD)/$(DATE)
ALL := $(wildcard $(YEARTD)/*.tex)
# another template is possible
MEETING := $(YEARTD)/$(DATE)-meeting
#MEETING := $(YEARTD)/2019-05-09-meeting
# LOGFILE := $(YEAR)-Research-Diary.log
# DVIFILE := $(YEAR)-Research-Diary.dvi
# PSFILE := $(YEAR)-Research-Diary.ps
# PDFFILE := $(YEAR)-Research-Diary.pdf
# AUXFILE := $(YEAR)-Research-Diary.aux
# OUTFILE := $(YEAR)-Research-Diary.out

# anthology:
#     -@echo 'Creating anthology for research diary entries from the year $(YEAR)'
#     -@$(SHELL) scripts/create_anthology.sh "$(YEAR)" "$(AUTHOR)" "$(INSTITUTION)"
#     -latex -interaction=batchmode -halt-on-error $(TEXFILE)
#     -dvips -q -o "$(PSFILE)" "$(DVIFILE)" -R0
#     -ps2pdf "$(PSFILE)" "$(PDFFILE)"
#     -okular $(PDFFILE)

# clean:
#     -$(RM) $(TEXFILE)
#     -$(RM) $(LOGFILE) $(DVIFILE) $(PSFILE) $(AUXFILE) $(OUTFILE)
#     -$(RM) *.tmp
#     -@echo 'Done cleaning'

.PHONY: today
today:
	$(shell ADDENTRY_SCRIPT $<)
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILETD)

.PHONY: entry # to force the new entry to be copied
entry:
	$(ADDENTRY_SCRIPT) -f
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILETD)

.PHONY: meeting
meeting:
	# ./src/add_meeting.sh assumes the meeting is already added otherwise overwrite the
	# correct date
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(MEETING)

.PHONY: all
all:
	$(ADDENTRY_SCRIPT)
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(ALL)

.PHONY: pdf
pdf:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: watch
watch:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -pvc -halt-on-error $(FILE)

.PHONY: watchtd
watchtd:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -pvc -halt-on-error $(FILETD)

.PHONY: clean
clean:
	rm -rf $(filter-out $(wildcard $(OUT)/*.pdf), $(wildcard $(OUT)/*))

.PHONY: purge
purge:
	rm -rf $(OUT)
