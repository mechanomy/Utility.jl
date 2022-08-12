# following https://juliadocs.github.io/Documenter.jl/stable/man/guide/

using Documenter
using DocumenterTools
using DocStringExtensions
using Utility

makedocs(
  sitename="Utility.jl",
  modules=[Utility],
  root = joinpath(dirname(pathof(Utility)), "..", "docs"),
  source = "src",
  build = "build",
  clean=true,
  doctest=true,
  draft=false,
  checkdocs=:all,
  # linkcheck=true, fails to find internal links to bookmarks..
  )

# compile custom theme scss in to css, copying over the default themes
DocumenterTools.Themes.compile("docs/src/assets/themes/documenter-mechanomy.scss", "docs/build/assets/themes/documenter-dark.css")
DocumenterTools.Themes.compile("docs/src/assets/themes/documenter-mechanomy.scss", "docs/build/assets/themes/documenter-light.css")

deploydocs(
  root = joinpath(dirname(pathof(Utility)), "..", "docs"),
  target = "build",
  dirname = "",
  repo = "github.com/mechanomy/Utility.jl.git",
  branch = "gh-pages",
  deps = nothing, 
  make = nothing,
  devbranch = "main",
  devurl = "dev",
  versions = ["stable" => "v^", "v#.#", "dev" => "dev"],
  forcepush = false,
  deploy_config = Documenter.auto_detect_deploy_system(),
  push_preview = false,
)

