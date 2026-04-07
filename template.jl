using PkgTemplates

const MY_PKG_TEMPLATE = Template(;
    user="dpb-hydro",
    dir="~",
    julia=v"1.11",
    plugins=[
        GitHubActions(; extra_versions=["pre"], coverage=false),
        Git(; branch="main", manifest=false),
        TagBot(),
        CompatHelper(),
        Tests(; aqua=true),
        Readme(; inline_badges=true, badge_order=[GitHubActions, BlueStyleBadge]),
    ],
)
