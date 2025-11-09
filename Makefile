POSTER_TEX := assets/posters/countdown_poster.tex
POSTER_PDF := assets/posters/countdown_poster.pdf
ENGINE := xelatex
ENGINE_FLAGS := -interaction=nonstopmode -halt-on-error

.PHONY: all poster clean distclean

all: poster

poster: $(POSTER_PDF)

$(POSTER_PDF): $(POSTER_TEX)
	@echo "Building poster with $(ENGINE)…"
	$(ENGINE) $(ENGINE_FLAGS) -output-directory=$(dir $@) $<

clean:
	@rm -f assets/posters/*.aux assets/posters/*.log assets/posters/*.out assets/posters/*.toc

distclean: clean
	@rm -f $(POSTER_PDF)

