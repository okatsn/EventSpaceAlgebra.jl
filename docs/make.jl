using EventSpaceAlgebra
using Documenter

DocMeta.setdocmeta!(EventSpaceAlgebra, :DocTestSetup, :(using EventSpaceAlgebra); recursive=true)

makedocs(;
    modules=[EventSpaceAlgebra],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/EventSpaceAlgebra.jl/blob/{commit}{path}#{line}",
    sitename="EventSpaceAlgebra.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/EventSpaceAlgebra.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Event Time" => "event_time.md",
    ],
)

deploydocs(;
    repo="github.com/okatsn/EventSpaceAlgebra.jl",
    devbranch="main",
)
