# Gemini CLI Project Context: Meno (Inklings)

## 🛠 Active Agent Skills & Tooling
- **State Management:** Use `watch-it-expert` for reactive UI and widget-scoped state.
- **Async Operations:** Use `command-it-expert` for all functional commands, loaders, and action restrictions.
- **Data Streaming:** Use `listen-it-expert` for complex reactive pipelines and `feed-datasource-expert` for all paginated lists/infinite scrolls.
- **Architecture:** Use `get-it-expert` to validate DI while adhering to DDD principles and patterns.

## 🏗 Architecture & DDD (Domain-Driven Design)
- **Layers:** Separate code into `infrastructure`, `domain`, `presentation`, and `application`.
- **Data Sources:** - Use Repository pattern to abstract logic.
    - Suffix files by source: `<name>_http_data_source`, `<name>_socket_data_source`, or `<name>_local_data_source`.
- **Mixins:** Use the custom `MLogger` mixin for all class-level logging.

## 📱 Flutter & Dart Standards
- **Reactive UI:** Strictly prefer `WatchingWidget` (from `watch_it`) over `StatefulWidget`.
    - Use `watch_it` lifecycle functions (`registerHandler`, `createOnce`, `callOnce`, etc.) for side effects, etc.
    - Only fallback to `StatefulWidget` if requirements are impossible to meet with `WatchingWidget`.
- **Optimization:** - Always use `const` constructors.
    - Adhere to "Effective Dart" guidelines.
    - Maintain zero `dart analyze` warnings.

## 🤖 Gemini Interaction Style
- **Expert Invocation:** When I ask about a feature, check which "Expert" skill in `~/.agents/skills` is most relevant before answering.
- **DDD Context:** Always specify which layer (`infrastructure`, `domain`, etc.) a suggested code snippet belongs to.
- **Performance:** Prioritize lazy loading and minimize `build()` method logic.