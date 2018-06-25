# Makefile for ocaml-lens; uses jbuilder

all:
	@ echo "Building ocaml-lens via jbuilder"
	@ jbuilder build @install

install:
	@ echo "Installing ocaml-lens via jbuilder"
	@ jbuilder install

clean:
	@ echo "Cleaning ocaml-lens via jbuilder"
	@ jbuilder clean

.PHONY: all install clean
