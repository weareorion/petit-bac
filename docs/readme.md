Add these lines (a new tool and new recipe) in your settings.json file : 

    "latex-workshop.latex.recipes": [
        {
            "name": "Texify (LuaTeX + shell-escape)",
            "tools": ["texify-luatex-shell-escape"]
        },
        {
            "name": "LuaLaTeX → PythonTeX → LuaLaTeX",
            "tools": [
                "texify-luatex-shell-escape",
                "pythontex",
                "texify-luatex-shell-escape"
            ]
        }

    ],
    "latex-workshop.latex.tools": [
        {
            "name": "texify-luatex-shell-escape",
            "command": "texify",
            "args": [
            "--pdf",
            "--engine=luatex",
            "--tex-option=-shell-escape",
            "%DOC_EXT%"
            ]
        },
        {
            "name": "pythontex",
            "command": "pythontex",
            "args": ["%DOC_EXT%"]
        },
    ],