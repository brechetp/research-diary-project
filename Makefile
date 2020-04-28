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
YEAR := $(shell date +%G)
MONTH := $(shell date +%m)
DAY := $(shell date +%d)

# TEXFILE=$year-$month-$day.tex
# PSFILE=$year-$month-$day.ps
# DVIFILE=$year-$month-$day.dvi
# PDFFILE=$year-$month-$day.pdf
#
RM := rm -rf
SHELL := /bin/zsh
#


DIR := $(YEAR)
ALL := $(wildcard $(DIR)/*.tex)

OUT  := build
# export TEXINPUTS := ./src/:$(TEXINPUTS)
export TEXINPUTS := ./include/:$(TEXINPUTS)


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

.PHONY: file
file:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: last
last:
	#$(ADDENTRY_SCRIPT)
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: entry # to force the new entry to be copied
entry:
	$(eval FILE := $(DIR)/$(shell $(ADDENTRY_SCRIPT) $(TITLE)))
	@echo $(FILE)
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: seminar
seminar:
	$(eval FILE := $(DIR)/$($(SHELL) $(ADDENTRY_SCRIPT) -s $(TITLE)))
	# correct date
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: meeting
meeting:
	$(eval(FILE := $(SHELL) $(ADDENTRY_SCRIPT) -m $(TITLE))
	# correct date
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: all
all:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(ALL)

.PHONY: pdf
pdf:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -halt-on-error $(FILE)

.PHONY: watch
watch:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -pvc -halt-on-error $(FILE)

.PHONY: watchtd
watchtd:
	latexmk -interaction=nonstopmode -outdir=$(OUT) -pdf -pvc -halt-on-error $(FILE)

.PHONY: clean
clean:
	rm -rf $(filter-out $(wildcard $(OUT)/*.pdf), $(wildcard $(OUT)/*))
	rm -rf $(filter-out $(wildcard $(YEAR)/*.tex) $(wildcard $(YEAR)/*.sty), $(wildcard $(YEAR)/*))

.PHONY: purge
purge:
	rm -rf $(OUT)
