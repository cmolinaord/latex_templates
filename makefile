NAME = main

OUTPUT_DIR = pdf
SRC_DIR = tex
TEX = latexmk -cd- -pdf -outdir=$(OUTPUT_DIR)

.PHONY: all $(NAME) $(NAME)_prev clean clean_all count_words debug_label_chapters debug_warnings
.SILENT: all $(NAME)_prev count_words debug_label_chapters debug_warnings

all:
	echo "make $(NAME):                      Compile $(NAME) from latex to pdf into pdf/ dir"
	echo "make $(NAME)_prev:                 Show the $(NAME) pdf result"
	echo "make clean:                        Remove the auxiliary files and logs in the output dir"
	echo "make clean_all:                    Remove all files in output dir, incluiding *.pdf"

# MAIN
##############################
$(NAME): $(OUTPUT_DIR)/$(NAME).pdf

$(OUTPUT_DIR)/$(NAME).pdf: $(SRC_DIR)/$(NAME).tex
	mkdir -p $(OUTPUT_DIR)
	$(TEX) $(SRC_DIR)/$(NAME).tex

$(NAME)_prev: $(NAME)
	$(TEX) $(SRC_DIR)/$(NAME).tex -pv

# Miscelaneous
##############################

clean:
	rm $(OUTPUT_DIR)/*{aux,log,toc}

clean_all:
	rm $(OUTPUT_DIR)/*

count_words:
	pdftotext "$(OUTPUT_DIR)/$(NAME).pdf" - |grep -v "^[0-9]" | wc -w

debug_label_chapters:
	echo "Mostrando capitulos que no tienen ningun /label"
	cat $(SRC_DIR)/*.tex | grep -E '(\\chapter|\\section)' | grep -v -E '\\label'

debug_warnings:
	echo "Mostrando lineas con WARNINGS:"
	grep -n -A1 "^%WARNING" tex/* | grep -v "WARNING" | sed 's/-%/: /'
	echo " "
