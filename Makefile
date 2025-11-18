POSTER_TEX := assets/posters/countdown_poster.tex
POSTER_PDF := assets/posters/countdown_poster.pdf
NOTICE_TEX := assets/posters/anniversary_notice.tex
NOTICE_A5_PDF := assets/posters/anniversary_notice.pdf
NOTICE_A4_PDF := assets/posters/anniversary_notice_a4.pdf
PDFJAM := /Library/TeX/texbin/pdfjam
ENGINE := xelatex
ENGINE_FLAGS := -interaction=nonstopmode -halt-on-error

.PHONY: all poster notice notice-a5 notice-a4 clean distclean force-notice force-poster

all: poster notice-a4

poster: $(POSTER_PDF)

notice: notice-a4

notice-a5: $(NOTICE_A5_PDF)

notice-a4: $(NOTICE_A4_PDF)

$(POSTER_PDF): $(POSTER_TEX)
	@echo "Building poster with $(ENGINE)…"
	$(ENGINE) $(ENGINE_FLAGS) -output-directory=$(dir $@) $<
	$(ENGINE) $(ENGINE_FLAGS) -output-directory=$(dir $@) $<

$(NOTICE_A5_PDF): $(NOTICE_TEX)
	@echo "Building A5 notice with $(ENGINE)…"
	$(ENGINE) $(ENGINE_FLAGS) -output-directory=$(dir $@) $<
	$(ENGINE) $(ENGINE_FLAGS) -output-directory=$(dir $@) $<

$(NOTICE_A4_PDF): $(NOTICE_A5_PDF)
	@echo "Combining two A5 pages into A4 with pdfjam…"
	$(PDFJAM) --nup 1x2 --a4paper $(NOTICE_A5_PDF) '1,1' -o $@

clean:
	@rm -f assets/posters/*.aux assets/posters/*.log assets/posters/*.out assets/posters/*.toc
	@rm -f $(POSTER_PDF) $(NOTICE_A5_PDF) $(NOTICE_A4_PDF)

distclean: clean
	@rm -f $(POSTER_PDF) $(NOTICE_A5_PDF) $(NOTICE_A4_PDF)

force-notice:
	@rm -f $(NOTICE_A5_PDF) $(NOTICE_A4_PDF)
	@$(MAKE) notice-a4

force-poster:
	@rm -f $(POSTER_PDF)
	@$(MAKE) poster

