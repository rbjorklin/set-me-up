local status, codecompanion = pcall(require, "codecompanion")
if (not status) then return end

codecompanion.setup({
  adapters = {
    kimi_k2 = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        formatted_name = "Kimi K2",
        env = {
          url = "https://api.moonshot.ai",
          api_key = "cmd:op read --no-newline 'op://Personal/Kimi K2 - Moonshot AI/credential'",
          chat_url = "/v1/chat/completions", -- optional: default value, override if different
          models_endpoint = "/v1/models", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
        },
        schema = {
          model = {
            default = "kimi-k2-0711-preview",
          },
          -- https://community.openai.com/t/cheat-sheet-mastering-temperature-and-top-p-in-chatgpt-api/172683
          temperature = {
            order = 2,
            mapping = "parameters",
            type = "number",
            optional = true,
            default = 0.2,  -- 0.2 or 0.3 are recommended by OpenAi for code.
            desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
            validate = function(n)
              return n >= 0 and n <= 2, "Must be between 0 and 2"
            end,
          },
          max_completion_tokens = {
            order = 3,
            mapping = "parameters",
            type = "integer",
            optional = true,
            -- https://platform.moonshot.ai/docs/pricing/chat#generation-model-kimi-latest
            default = 131072,  -- Kimi K2 max context length
            desc = "An upper bound for the number of tokens that can be generated for a completion.",
            validate = function(n)
              return n > 0, "Must be greater than 0"
            end,
          },
          stop = {
            order = 4,
            mapping = "parameters",
            type = "string",
            optional = true,
            default = nil,
            desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
            validate = function(s)
              return s:len() > 0, "Cannot be an empty string"
            end,
          },
          logit_bias = {
            order = 5,
            mapping = "parameters",
            type = "map",
            optional = true,
            default = nil,
            desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
            subtype_key = {
              type = "integer",
            },
            subtype = {
              type = "integer",
              validate = function(n)
                return n >= -100 and n <= 100, "Must be between -100 and 100"
              end,
            },
          },
          -- https://platform.openai.com/docs/api-reference/responses/create#responses-create-top_p
          top_p = {
            order = 6,
            mapping = "parameters",
            type = "number",
            optional = true,
            default = 0.1,  -- 0.1 or 0.2 are recommended for code.
            desc = "An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.",
            validate = function(n)
              return n >= 0 and n <= 2, "Must be between 0 and 2"
            end,
          },
        },
      })
    end,
    deepseek_r1 = function()
      return require("codecompanion.adapters").extend("deepseek", {
        formatted_name = "DeepSeek R1",
        env = {
          api_key = "cmd:op read --no-newline 'op://Personal/DeepSeek - API Key/credential'",
        },
        schema = {
          model = {
            default = "deepseek-reasoner",
          },
          -- https://community.openai.com/t/cheat-sheet-mastering-temperature-and-top-p-in-chatgpt-api/172683
          temperature = {
            -- DeepSeek actually recommends a temperature of 0 for code.
            -- https://api-docs.deepseek.com/quick_start/parameter_settings
            default = 0.0,  -- 0.2 or 0.3 are recommended by OpenAI for code.
          },
          max_tokens = {
            -- https://api-docs.deepseek.com/quick_start/pricing
            default = 65536,  -- DeepSeek R1 max context length
          },
          -- https://platform.openai.com/docs/api-reference/responses/create#responses-create-top_p
          top_p = {
            default = 0.1,  -- 0.1 or 0.2 are recommended for code.
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "kimi_k2",
    },
    inline = {
      adapter = "kimi_k2",
    },
    cmd = {
      adapter = "kimi_k2",
    }
  },
})
