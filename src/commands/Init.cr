abstract class Emeralds::Init < Emeralds::Command
  def initialize(name = "", @silent = false)
    super name, @silent;
    if @name.empty?
      puts "Invalid name: #{name}.".colorize(:red);
      exit 0;
    end
  end

  private def create_lib_directory
    if File.exists? @name
      puts "#{ARROW} An emerald with name: #{@name} already exists.".colorize(:yellow);
      exit 0;
    else
      puts "#{COG} Creating directory: #{@name.colorize(:green).mode(:bold)}";
      Terminal.mkdir @name;
    end
  end

  private def initialize_git_directory
    puts "  #{ARROW} .git";
    Terminal.git_init;
  end

  private def generate_readme
    puts "  #{ARROW} README.md";

    result = String.build do |data|
      data << "# #{@name}\n\n";

      data << "[![MIT License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)\n\n";

      data << "TODO: Write a description here\n\n";

      data << "# Installation\n\n";

      data << "TODO: Write installation instructions here\n\n";

      data << "## Usage\n\n";

      data << "TODO: Write usage instructions here\n\n";

      data << "## Contributing\n\n";

      data << "1. Fork it (<https://github.com/your-github-user/#{@name}/fork>)\n";
      data << "2. Create your feature branch (`git checkout -b my-new-feature`)\n";
      data << "3. Commit your changes (`git commit -am 'Add some feature'`)\n";
      data << "4. Push to the branch (`git push origin my-new-feature`)\n";
      data << "5. Create a new Pull Request\n\n";

      data << "## Contributors\n\n";

      data << "- [YourName](https://github.com/your-github-user) - creator and maintainer\n";
      data << "";
    end

    File.write "README.md", result;
  end

  private def create_agents_symlinks
    puts "  #{ARROW} CLAUDE.md -> AGENTS.md";
    File.symlink "AGENTS.md", "CLAUDE.md";

    puts "  #{ARROW} GEMINI.md -> AGENTS.md";
    File.symlink "AGENTS.md", "GEMINI.md";

    puts "  #{ARROW} .cursorrules -> AGENTS.md";
    File.symlink "AGENTS.md", ".cursorrules";
  end

  private def write_claude_settings
    puts "  #{ARROW} .claude/settings.local.json";

    Terminal.mkdir ".claude";

    result = String.build do |data|
      data << "{\n";
      data << "  \"defaultMode\": \"bypassPermissions\",\n";
      data << "  \"permissions\": {\n";
      data << "    \"allow\": [\n";
      data << "      \"Bash(*)\",\n";
      data << "      \"Edit(*)\",\n";
      data << "      \"ExitPlanMode(*)\",\n";
      data << "      \"Monitor(*)\",\n";
      data << "      \"NotebookEdit(*)\",\n";
      data << "      \"PowerShell(*)\",\n";
      data << "      \"Read(*)\",\n";
      data << "      \"ShareOnboardingGuide(*)\",\n";
      data << "      \"Skill(*)\",\n";
      data << "      \"WebFetch(*)\",\n";
      data << "      \"WebSearch(*)\",\n";
      data << "      \"Workflow(*)\",\n";
      data << "      \"Write(*)\"\n";
      data << "    ]\n";
      data << "  }\n";
      data << "}\n";
    end

    File.write (File.join ".claude", "settings.local.json"), result;
  end

  private def write_opencode_settings
    puts "  #{ARROW} .opencode/opencode.json";

    Terminal.mkdir ".opencode";

    result = String.build do |data|
      data << "{\n";
      data << "  \"$schema\": \"https://opencode.ai/config.json\",\n";
      data << "  \"experimental\": {\n";
      data << "    \"disable_paste_summary\": true\n";
      data << "  },\n";
      data << "  \"permission\": {\n";
      data << "    \"*\": \"allow\"\n";
      data << "  }\n";
      data << "}\n";
    end

    File.write (File.join ".opencode", "opencode.json"), result;
  end

  protected def write_agents_common(data)
    data << "# AGENTS.md\n\n";

    data << "Behavioral guidelines to reduce common LLM coding mistakes. Merge with\n";
    data << "project-specific instructions as needed.\n\n";

    data << "**Tradeoff:** These guidelines bias toward caution over speed. For trivial\n";
    data << "tasks, use judgment.\n\n";

    data << "## 0. Non-negotiables\n\n";

    data << "These override everything else:\n\n";

    data << "1. **No flattery, no filler.** Start with the answer or action.\n";
    data << "2. **Disagree when you disagree.** Never agree with false premises to be polite.\n";
    data << "3. **Never fabricate.** If you don't know, read the file, run the command, or\n";
    data << "   say so.\n";
    data << "4. **Touch only what you must.** Every changed line must trace to the user's\n";
    data << "   request.\n";
    data << "5. **NO committing from an agent!!** (human commits only).\n";
    data << "6. **Do not write comments** unless they are javadoc style comments. Even\n";
    data << "   in that case, only write them if the project looks like a library not an app.\n\n";

    data << "### You are a lazy senior developer. Lazy means efficient, not careless. The best code is the code never written.\n\n";

    data << "Before writing any code, stop at the first rung that holds:\n\n";

    data << "1. Does this need to be built at all? (YAGNI)\n";
    data << "2. Does the standard library already do this? Use it.\n";
    data << "3. Does a native platform feature cover it? Use it.\n";
    data << "4. Does an already-installed dependency solve it? Use it.\n";
    data << "5. Can this be one line? Make it one line.\n";
    data << "6. Only then: write the minimum code that works.\n\n";

    data << "Rules:\n\n";

    data << "- No abstractions that weren't explicitly requested.\n";
    data << "- No new dependency if it can be avoided.\n";
    data << "- No boilerplate nobody asked for.\n";
    data << "- Deletion over addition. Boring over clever. Fewest files possible.\n";
    data << "- Question complex requests: `Do you actually need X, or does Y cover it?`\n";
    data << "- Pick the edge-case-correct option when two stdlib approaches are the same\n";
    data << "  size, lazy means less code, not the flimsier algorithm.\n\n";

    data << "Not lazy about: input validation at trust boundaries, error handling that\n";
    data << "prevents data loss, security, accessibility, anything explicitly requested.\n";
    data << "Non-trivial logic leaves ONE runnable check behind, the smallest thing that\n";
    data << "fails if the logic breaks (an assert-based demo/self-check or one small test\n";
    data << "file; no frameworks, no fixtures). Trivial one-liners need no test.\n\n";

    data << "## 1. Think Before Coding\n\n";

    data << "**Don't assume. Don't hide confusion. Surface tradeoffs.**\n\n";

    data << "Before implementing:\n\n";

    data << "- State your assumptions explicitly. If uncertain, ask.\n";
    data << "- If multiple interpretations exist, present them - don't pick silently.\n";
    data << "- If a simpler approach exists, say so. Push back when warranted.\n";
    data << "- If something is unclear, stop. Name what's confusing. Ask.\n\n";

    data << "## 2. Simplicity First\n\n";

    data << "**Minimum code that solves the problem. Nothing speculative.**\n\n";

    data << "- No features beyond what was asked.\n";
    data << "- No abstractions for single-use code.\n";
    data << "- No \"flexibility\" or \"configurability\" that wasn't requested.\n";
    data << "- No error handling for impossible scenarios.\n";
    data << "- If you write 200 lines and it could be 50, rewrite it.\n";
    data << "- If you write 20 lines and it be 5, rewrite it.\n\n";

    data << "Ask yourself: \"Would a senior engineer say this is overcomplicated?\" If yes,\n";
    data << "simplify.\n\n";

    data << "## 3. Surgical Changes\n\n";

    data << "**Touch only what you must. Clean up only your own mess.**\n\n";

    data << "When editing existing code:\n\n";

    data << "- Don't \"improve\" adjacent code, comments, or formatting.\n";
    data << "- Don't refactor things that aren't broken.\n";
    data << "- Match existing style, even if you'd do it differently.\n";
    data << "- If you notice unrelated dead code, mention it - don't delete it.\n\n";

    data << "When your changes create orphans:\n\n";

    data << "- Remove imports/variables/functions that YOUR changes made unused.\n";
    data << "- Don't remove pre-existing dead code unless asked.\n\n";

    data << "The test: Every changed line should trace directly to the user's request.\n\n";

    data << "## 4. Goal-Driven Execution\n\n";

    data << "**Define success criteria. Loop until verified.**\n\n";

    data << "Transform tasks into verifiable goals:\n\n";

    data << "- \"Add validation\" → \"Write tests for invalid inputs, then make them pass\"\n";
    data << "- \"Fix the bug\" → \"Write a test that reproduces it, then make it pass\"\n";
    data << "- \"Refactor X\" → \"Ensure tests pass before and after\"\n\n";

    data << "For multi-step tasks, state a brief plan:\n\n";

    data << "```\n";
    data << "1. [Step] → verify: [check]\n";
    data << "2. [Step] → verify: [check]\n";
    data << "3. [Step] → verify: [check]\n";
    data << "```\n\n";

    data << "Strong success criteria let you loop independently. Weak criteria (\"make it\n";
    data << "work\") require constant clarification.\n\n";

    data << "---\n\n";

    data << "**These guidelines are working if:** fewer unnecessary changes in diffs, fewer\n";
    data << "rewrites due to overcomplication, and clarifying questions come before\n";
    data << "implementation rather than after mistakes.\n\n";
  end

  abstract def write_language_files;

  def message
    "Emeralds - Initializing a new project";
  end

  def block
    -> {
      create_lib_directory;
      Dir.cd @name do
        puts "#{COG} Writing initial files:";

        initialize_git_directory;
        write_language_files;
        create_agents_symlinks;
        write_claude_settings;
        write_opencode_settings;
        License.new.wget_license;
        generate_readme;
      end
    };
  end
end
