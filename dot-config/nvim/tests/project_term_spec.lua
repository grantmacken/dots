describe("project_term module", function()
  local project_term

  before_each(function()
    project_term = require("project_term")
  end)

  after_each(function()
    package.loaded["project_term"] = nil
  end)

  describe("version", function()
    it("should have a version string", function()
      assert.is_not_nil(project_term.version)
      assert.is_string(project_term.version)
    end)

    it("should match semantic versioning format", function()
      assert.matches("^%d+%.%d+%.%d+$", project_term.version)
    end)

    it("should be version 0.1.0", function()
      assert.equals("0.1.0", project_term.version)
    end)
  end)


  describe("tabpage_term_buffer", function()
    it("should return number", function()
      assert.is_not_nil(project_term.tabpage_term_buffer())
      -- assert.is_number(project_term.tabpage_term_buffer())
    end)
    it("should set tabpage variable", function()
      assert.equals(vim.t.project['term_buf_id'], project_term.tabpage_term_buffer())
    end)
  end)
end)
