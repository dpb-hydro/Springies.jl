using JuliaFormatter
formatted = format("."; verbose=true)
if !formatted
    @error "Code is not formatted. Run format(\".\") locally."
    exit(1)
end
