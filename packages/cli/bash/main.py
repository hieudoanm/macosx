import os


def main():
    src_dir = "src"
    dist_dir = "dist"

    # Ensure dist directory exists
    os.makedirs(dist_dir, exist_ok=True)

    scripts = os.listdir(src_dir)
    scripts.sort()

    # --------------------------------
    # Build README.md (Markdown output)
    # --------------------------------
    markdown_sections = []

    # Add curl installation command at the top
    install_cmd = "```bash\ncurl -fsSL https://raw.githubusercontent.com/hieudoanm/bash/master/install.sh | bash\n```"
    markdown_sections.append(install_cmd)

    for script in scripts:
        name = script.replace(".bash", "")
        with open(os.path.join(src_dir, script), "r", encoding="utf-8") as f:
            content = f.read()
        section = f"## {name}\n\n```bash\n{content}```"
        markdown_sections.append(section)

    markdown = "# Bash\n\n" + "\n\n".join(markdown_sections)

    with open("README.md", "w", encoding="utf-8") as f:
        f.write(markdown)

    # --------------------------------
    # Build full.bash (combined output)
    # --------------------------------
    bash_parts = []
    for script in scripts:
        with open(os.path.join(src_dir, script), "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("#!/bin/bash", "").strip()
        bash_parts.append(content)

    bash = "#!/bin/bash\n\n" + "\n\n".join(bash_parts)

    with open(os.path.join(dist_dir, "full.bash"), "w", encoding="utf-8") as f:
        f.write(bash)


if __name__ == "__main__":
    main()
