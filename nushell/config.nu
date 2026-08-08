# config.nu - Nushell Configuration optimized for WezTerm & Windows Performance
# Version: 0.114.1+

# ------------------------------------------------------------------------------
# 1. Startup & Performance Optimization
# ------------------------------------------------------------------------------
# Disables startup welcome banner for instant prompt load times
$env.config.show_banner = false

# Enable safe bracketed pasting for multi-line code snippets
$env.config.bracketed_paste = true

# ------------------------------------------------------------------------------
# 2. WezTerm & ConPTY Display Fixes
# ------------------------------------------------------------------------------
# 1. Stops Nushell from sending OSC 133 sequences that force WezTerm to scroll down
$env.config.shell_integration.osc133 = false

# 2. Stops Nushell from recalculating right prompt layout on every keypress
$env.config.render_right_prompt_on_last_line = false

# ------------------------------------------------------------------------------
# 3. Auto-Completions Optimization
# ------------------------------------------------------------------------------
$env.config.completions = ($env.config | get -o completions | default {} | merge {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
})

# ------------------------------------------------------------------------------
# 4. History Management
# ------------------------------------------------------------------------------
$env.config.history = ($env.config | get -o history | default {} | merge {
    max_size: 100000
    sync_on_enter: true
    file_format: "plaintext"
})

# ------------------------------------------------------------------------------
# 5. Table & Display UI Styling
# ------------------------------------------------------------------------------
$env.config.table = ($env.config | get -o table | default {} | merge {
    mode: rounded
    show_empty: true
})


