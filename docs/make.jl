using PhaseOnlyCorrelation
using Documenter

DocMeta.setdocmeta!(PhaseOnlyCorrelation, :DocTestSetup, :(using PhaseOnlyCorrelation); recursive=true)

makedocs(;
    modules=[PhaseOnlyCorrelation],
    authors="Arnold",
    repo="https://github.com/a-r-n-o-l-d/PhaseOnlyCorrelation.jl/blob/{commit}{path}#{line}",
    sitename="PhaseOnlyCorrelation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://a-r-n-o-l-d.github.io/PhaseOnlyCorrelation.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/a-r-n-o-l-d/PhaseOnlyCorrelation.jl",
    devbranch="main",
)
