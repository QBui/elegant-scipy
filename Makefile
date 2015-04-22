# This Makefile builds an HTML "book" from source files written in
#     Markdown.

# VPATH: where to look for source files. This is a Makefile built-in
#     special variable.
VPATH = markdown

# BUILD_{HTML,NB}: where to put the output HTML files and the
#     intermediate IPython notebooks.
BUILD_HTML = build_html
BUILD_NB = build_ipynb

# TITLES: This should be an exhaustive list of all the chapters to be
#     built, and correspond to markdown filenames in the markdown
#     directory.
TITLES := preface ch2

# CHS_, chs: some Makefile magic that prefixes all the titles with the
#     HTML build directory, then suffixes them with the .html
#     extension. chs then constitutes the full list of targets.
CHS_ := $(addprefix $(BUILD_HTML)/,$(TITLES))
chs: $(addsuffix .html,$(CHS_))

# %.html: How to build an HTML file from its corresponding IPython
#     notebook.
$(BUILD_HTML)/%.html: $(BUILD_NB)/%.ipynb
	 ipython nbconvert --to html $< --stdout > $@

# %.ipynb: How to build an IPython notebook from a source Markdown
#     file.
$(BUILD_NB)/%.ipynb: %.markdown
	 notedown --match fenced --run $< > $@

# .PHONY: Special Makefile variable specifying targets that don't
#     correspond to any actual files.
.PHONY: all build_dirs

# build_dirs: directories for build products
build_dirs:
	 mkdir -p build_ipynb
	 mkdir -p build_html

# all: build the book.
all: build_dirs chs

# clean: remove intermediate products (IPython notebooks)
clean:
	 rm -rf $(BUILD_NB)

clobber: clean
	 rm -rf $(BUILD_HTML)
