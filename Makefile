.PHONY: serve stop install clean pdf export open help

# Default port for the local server
PORT ?= 9628

# Default target
help:
	@echo "C++Now 2026 Coroutine Talk - Makefile targets:"
	@echo ""
	@echo "  make install   - Install npm dependencies"
	@echo "  make serve     - Start local dev server on port $(PORT)"
	@echo "  make open      - Open presentation in default browser"
	@echo "  make stop      - Stop running dev server"
	@echo "  make pdf       - Export slides to PDF (requires decktape)"
	@echo "  make export    - Export self-contained presentation to dist/"
	@echo "  make clean     - Remove generated files"
	@echo "  make help      - Show this help message"

# Install dependencies
install:
	npm install

# Start local development server
serve:
	@echo "Starting reveal.js presentation on http://localhost:$(PORT)"
	@npx serve . -l $(PORT) &
	@echo "Server running in background (PID: $$!)"

# Open in browser
open:
	@xdg-open http://localhost:$(PORT) 2>/dev/null || \
	 open http://localhost:$(PORT) 2>/dev/null || \
	 echo "Please open http://localhost:$(PORT) in your browser"

# Stop the server
stop:
	@pkill -f "serve . -l $(PORT)" 2>/dev/null && echo "Server stopped" || echo "No server running"

# Export to PDF using decktape
pdf:
	@command -v npx >/dev/null 2>&1 || { echo "npx not found"; exit 1; }
	npx decktape reveal http://localhost:$(PORT) slides.pdf --size 1920x1080

# Export self-contained presentation
export:
	@mkdir -p dist
	@cp index.html dist/
	@cp -r css dist/
	@cp -r img dist/ 2>/dev/null || true
	@cp -r code dist/ 2>/dev/null || true
	@cp -r slides dist/ 2>/dev/null || true
	@cp -r node_modules/reveal.js/dist dist/reveal.js-dist
	@cp -r node_modules/reveal.js/plugin dist/reveal.js-plugin
	@echo "Exported to dist/ - update paths in dist/index.html to use reveal.js-dist/ and reveal.js-plugin/"

# Clean generated files
clean:
	rm -rf dist slides.pdf
