# From https://gitlab.com/to1ne/literate-dotfiles
cache_dir := .cache
timestamps_dir := .timestamps
docs := README.org sitemap.org
orgs := $(filter-out $(docs), $(wildcard *.org))
emacs_pkgs := org

tangle_el := elisp/tangle.el

^el = $(filter %.el,$^)
EMACS.funcall = emacs --batch --no-init-file $(addprefix --load ,$(^el)) --funcall

test: tangle

clean:
	rm -rf $(timestamps_dir)
	rm -rf $(cache_dir)

tangle: $(basename $(orgs))

# https://emacs.stackexchange.com/a/27128/2780
$(cache_dir)/%.out: %.org $(tangle_el) $(cache_dir)/
	$(EMACS.funcall) literate-dotfiles-tangle $< > $@

%/:
	mkdir -p $@

%: %.org $(cache_dir)/%.out
	@$(NOOP)

git: emacs_pkgs = gitconfig-mode gitattributes-mode gitignore-mode

.PHONY: all clean
.PRECIOUS: $(cache_dir)/ $(cache_dir)/%.out
