# Self-hosted AI starter kit (shask)

**Self-hosted AI Starter Kit** is an open-source Docker Compose template designed to swiftly initialize a comprehensive local AI and low-code development environment.

![n8n.io - Screenshot](https://raw.githubusercontent.com/n8n-io/self-hosted-ai-starter-kit/main/assets/n8n-demo.gif)

Based on the [n8n-io self-hosted AI starter kit](https://github.com/n8n-io/self-hosted-ai-starter-kit)
and merged with [n8n’s one-line setup](https://get.n8n.io) (sandbox, task
runners, SearXNG). Stack files live under `n8n/`.

> [!TIP]
> [Read the announcement](https://blog.n8n.io/self-hosted-ai/)

### What’s included

✅ [**Self-hosted n8n**](https://n8n.io/) - Low-code platform with over 400
integrations and advanced AI components

✅ [**Ollama**](https://ollama.com/) - Cross-platform LLM platform to install
and run the latest local LLMs

✅ [**Qdrant**](https://qdrant.tech/) - Open-source, high performance vector
store with a comprehensive API

✅ [**PostgreSQL**](https://www.postgresql.org/) - Workhorse of the Data
Engineering world, handles large amounts of data safely

✅ [**SearXNG**](https://docs.searxng.org/) - Privacy-respecting metasearch
used by the n8n instance AI assistant for web search

✅ **n8n task runners + sandbox** - External Code-node runners and a
privileged Docker-in-Docker sandbox for the instance AI assistant (local
learning only; do not expose sandbox ports)

### What you can build

⭐️ **AI Agents** for scheduling appointments

⭐️ **Summarize Company PDFs** securely without data leaks

⭐️ **Smarter Slack Bots** for enhanced company communications and IT operations

⭐️ **Private Financial Document Analysis** at minimal cost

## Installation

### Cloning the Repository

```bash
git clone https://github.com/mondesirm/shask.git
cd shask
cp n8n/.env.example n8n/.env
./scripts/gen-secrets.sh   # unique secrets; keeps demo encryption key
```

> [!IMPORTANT]
> Always run Compose from `n8n/` (or use the root `Makefile`). The env file is
> `n8n/.env`.

### Running with Docker Compose

All commands below assume you are in the **repo root** and use the Makefile,
or you `cd n8n` and run `docker compose` there.

#### For Nvidia GPU users

```bash
make secrets
make up-gpu
# equivalent: docker compose --project-directory n8n -f n8n/compose.yml --profile gpu-nvidia up
```

> [!NOTE]
> If you have not used your Nvidia GPU with Docker before, please follow the
> [Ollama Docker instructions](https://docs.ollama.com/docker).

#### For AMD GPU users on Linux

```bash
make secrets
make up-amd
```

#### For Mac / Apple Silicon users

If you’re using a Mac with an M1 or newer processor, you can't expose your GPU
to the Docker instance. There are two options:

1. Run the starter kit fully on CPU (`make up-cpu`)
2. Run Ollama on your Mac for faster inference, and connect to that from n8n

If you want to run Ollama on your Mac, install it from the
[Ollama homepage](https://ollama.com/), then:

```bash
make secrets
# In n8n/.env, set:
#   OLLAMA_HOST=host.docker.internal:11434
make up-mac
```

After you see "Editor is now accessible via: <http://localhost:5678/>":

1. Open <http://localhost:5678/home/credentials>
2. Open **Local Ollama service**
3. Set the base URL to `http://host.docker.internal:11434/`

#### For everyone else (CPU)

```bash
make secrets
make up-cpu
```

## ⚡️ Quick start and usage

1. Open <http://localhost:5678/> in your browser to set up n8n (once).
2. Open the included workflow:
   <http://localhost:5678/workflow/srOnR8PAY3u4RSwb>
3. Click the **Chat** button at the bottom of the canvas.
4. On first run you may need to wait until Ollama finishes downloading
   Llama 3.2 — check the `ollama-pull-llama` container logs.

With your n8n instance you’ll have access to over 400 integrations and AI
nodes such as
[AI Agent](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/),
[Text classifier](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.text-classifier/),
and [Information Extractor](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.information-extractor/).
To keep everything local, use the Ollama node for your language model and
Qdrant as your vector store.

> [!NOTE]
> This starter kit is for learning and proof-of-concept. It is not hardened
> for production (no reverse proxy/TLS, privileged sandbox DinD, placeholder
> defaults until you run `gen-secrets.sh`). Customize as needed.

### Demo credentials and encryption key

Bundled credentials under `n8n/shared/credentials/` are encrypted with:

```text
N8N_ENCRYPTION_KEY=super-secret-key
```

`scripts/gen-secrets.sh` keeps that key (and `QDRANT_API_KEY=qdrant`) so the
demo workflow works. To rotate everything, including the encryption key:

```bash
./scripts/gen-secrets.sh --rotate-encryption-key
```

Then recreate the Ollama and Qdrant credentials in the n8n UI.

### Optional: expose Ollama or Qdrant on the host

By default those APIs stay on the Compose network only (n8n reaches them by
service name). To publish ports for local debugging, uncomment the `ports:`
blocks on the `ollama` / `qdrant` services in `n8n/compose.yml`.

### Optional: instance AI assistant model

Uncomment the `N8N_INSTANCE_AI_MODEL*` lines in `n8n/.env` after Ollama is
running if you want the built-in assistant wired to Llama 3.2 automatically.

## Upgrading

From the repo root (updates `N8N_VERSION` / `N8N_SANDBOX_VERSION` via get-n8n):

```bash
make bump
make pull PROFILE=cpu   # or gpu / amd
make up-cpu             # or up-gpu / up-amd / up-mac
```

Or manually:

```bash
cd n8n
docker compose --profile cpu pull
docker compose --profile cpu up
```

## 👓 Recommended reading

- [AI agents for developers: from theory to practice with n8n](https://blog.n8n.io/ai-agents/)
- [Tutorial: Build an AI workflow in n8n](https://docs.n8n.io/advanced-ai/intro-tutorial/)
- [Langchain Concepts in n8n](https://docs.n8n.io/advanced-ai/langchain/langchain-n8n/)
- [Demonstration of key differences between agents and chains](https://docs.n8n.io/advanced-ai/examples/agent-chain-comparison/)
- [What are vector databases?](https://docs.n8n.io/advanced-ai/examples/understand-vector-databases/)

## 🎥 Video walkthrough

- [Installing and using Local AI for n8n](https://www.youtube.com/watch?v=xz_X2N-hPg0)

## 🛍️ More AI templates

For more AI workflow ideas, visit the [**official n8n AI template
gallery**](https://n8n.io/workflows/categories/ai/). From each workflow,
select the **Use workflow** button to automatically import the workflow into
your local n8n instance.

### Learn AI key concepts

- [AI Agent Chat](https://n8n.io/workflows/1954-ai-agent-chat/)
- [AI chat with any data source (using the n8n workflow too)](https://n8n.io/workflows/2026-ai-chat-with-any-data-source-using-the-n8n-workflow-tool/)
- [Chat with OpenAI Assistant (by adding a memory)](https://n8n.io/workflows/2098-chat-with-openai-assistant-by-adding-a-memory/)
- [Use an open-source LLM (via Hugging Face)](https://n8n.io/workflows/1980-use-an-open-source-llm-via-huggingface/)
- [Chat with PDF docs using AI (quoting sources)](https://n8n.io/workflows/2165-chat-with-pdf-docs-using-ai-quoting-sources/)
- [AI agent that can scrape webpages](https://n8n.io/workflows/2006-ai-agent-that-can-scrape-webpages/)

### Local AI templates

- [Tax Code Assistant](https://n8n.io/workflows/2341-build-a-tax-code-assistant-with-qdrant-mistralai-and-openai/)
- [Breakdown Documents into Study Notes with MistralAI and Qdrant](https://n8n.io/workflows/2339-breakdown-documents-into-study-notes-using-templating-mistralai-and-qdrant/)
- [Financial Documents Assistant using Qdrant and Mistral.ai](https://n8n.io/workflows/2335-build-a-financial-documents-assistant-using-qdrant-and-mistralai/)
- [Recipe Recommendations with Qdrant and Mistral](https://n8n.io/workflows/2333-recipe-recommendations-with-qdrant-and-mistral/)

## Tips & tricks

### Accessing local files

`n8n/shared/` is mounted into the n8n container at `/data/shared`. It holds:

- **Demo import data** — `credentials/` and `workflows/` (imported once on
  first boot if no workflows exist yet)
- **Your files** — place documents here for Read/Write Files, Local File
  Trigger, and Execute Command nodes

Use container path `/data/shared/...` in those nodes.

**Nodes that interact with the local filesystem**

- [Read/Write Files from Disk](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.filesreadwrite/)
- [Local File Trigger](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.localfiletrigger/)
- [Execute Command](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.executecommand/)

## 📜 License

This project is licensed under the Apache License 2.0 - see the
[LICENSE](LICENSE) file for details.

## 💬 Support

Join the conversation in the [n8n Forum](https://community.n8n.io/), where you
can share work, ask questions, and propose ideas.
