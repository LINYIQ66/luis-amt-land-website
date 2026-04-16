# Luis Lin's Personal Website & AI Assistant

This repository hosts the codebase for Luis Lin's personal website and AI assistant, accessible at `3.luis.amt.land`. The site features a psychology feed, English reading practice, and other personal project pages, all served statically.

## Features

*   **Psychology Feed:** Dynamically updated industry psychology insights with text and Chinese TTS audio. Content is organized by time slots and auto-refreshes.
*   **English Reading Practice:** Interactive page for English reading and pronunciation practice. Features include:
    *   28 pre-generated audio files for each text, using Edge TTS (English dialects).
    *   Search and filter capabilities for selecting texts by difficulty and category.
    *   Recording functionality for user practice, with Whisper-based scoring.
    *   Optional login to save learning progress.
*   **Site-wide Navigation:** Consistent pink/lavender/mint themed bottom navigation bar across all pages.
*   **Password Protected Pages:** `tasks.html` and `status.html` are protected by a session-based password (`866568xx!`).
*   **Sitemap:** Provides an overview of all site sections.
*   **Static Site:** Primarily HTML, CSS, and JavaScript, served directly via Nginx without a backend server.
*   **Cache Control:** Implemented via HTML meta tags and Nginx configuration to ensure users always see the latest version.

## Technology Stack

*   **Frontend:** HTML, CSS, JavaScript
*   **TTS:** Edge TTS (for pre-generated English audio), CosyVoice (for Chinese audio, on CPU)
*   **Hosting:** Static files served via Nginx
*   **Automation:** Cron jobs for content generation.
*   **GitHub Interaction:** `gh` CLI authenticated with Personal Access Token (PAT).

## Directory Structure

The main website content is located in `/var/www/3.luis.amt.land/`. Key files include:
*   `index.html`: Main landing page.
*   `psychology-feed.html`: Psychology content feed UI.
*   `psychology-feed.json`: Data source for the psychology feed.
*   `english-reading.html`: English reading practice page.
*   `audio/`: Directory containing pre-generated TTS audio files.
*   `sitemap.html`: Site map.
*   `tasks.html`, `status.html`: Password-protected pages.
*   `training.html`: Training documentation.

## Deployment Notes

The website is deployed as static files on a server, served by Nginx. Updates are typically made by modifying files in `/var/www/3.luis.amt.land/`, committing them to the Git repository, and pushing to this GitHub repository. Cache control measures ensure updates are reflected promptly.

## Future Work

*   Integrate ElevenLabs API for higher quality English TTS audio (requires a valid paid key).
*   Enhance AI features and content generation.
*   Refine login/authentication mechanisms.

## GitHub Authentication

Authentication for GitHub operations is handled via `gh` CLI, authenticated with a Personal Access Token (PAT). Git configuration (`user.name`, `user.email`) is set locally for repository operations.
