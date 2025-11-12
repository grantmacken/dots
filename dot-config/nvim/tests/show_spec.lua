describe("show module", function()
  before_each(function()
    show = require("show")
  end)

  after_each(function()
    package.loaded["show"] = nil
  end)

  describe("version", function()
    it("should have a version string", function()
      assert.is_not_nil(show.version)
      assert.is_string(show.version)
    end)

    it("should match semantic versioning format", function()
      assert.matches("^%d+%.%d+%.%d+$", show.version)
    end)

    it("should be version 0.1.0", function()
      assert.equals("0.1.0", show.version)
    end)
  end)
end)
