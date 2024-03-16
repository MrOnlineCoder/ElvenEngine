#pragma once

#include "Events/ApplicationEvent.h"
#include "Events/EventHandler.h"
#include "Scene/Entity.h"

#if EDITOR_MODE
#    include "ImGui/ImGuiOverlay.h"
#endif

namespace elv {

class Window;
class Application {
private:
    struct Telemetry {
        float frameTime { 0.0f };
        float fps { 0.0f };
    };

public:
    Application();
    virtual ~Application();
    Application(const Application&) = delete;
    const Application& operator=(const Application&) = delete;

    void Run();

    UniquePtr<Window>& GetWindow() { return m_window; }

    static Application& Get() { return *s_instance; }
    static Telemetry& GetTelemetry() { return s_telemetry; };

    ecs::Entity GetOrthographicCameraEntity() const { return m_orthoCameraEntity; }

protected:
    virtual void OnCreate() {};
    virtual void OnUpdate(float dt) {};
    virtual void OnRender(float dt) {};
    virtual void OnProcessInput(float dt) {};
#if EDITOR_MODE
    virtual void OnImguiRender() {};
#endif
    virtual void OnDestroy() {};

    virtual void OnWindowResizeApp() {};

private:
    void OnWindowClose(const events::WindowCloseEvent& e);
    void OnWindowResize(const events::WindowResizeEvent& e);

protected:
    ecs::Entity m_orthoCameraEntity { ecs::INVALID_ENTITY_ID };
    bool m_running { false };

private:
    static Application* s_instance;
    static Telemetry s_telemetry;

    UniquePtr<Window> m_window { nullptr };
    ecs::Entity m_fpsCounterEntityId { 0 };
    bool m_isPaused { false };

#if EDITOR_MODE
    ImGuiOverlay m_imGuiOverlay;
#endif

    events::EventHandler<events::WindowResizeEvent> m_windowResizeCallback;
    events::EventHandler<events::WindowCloseEvent> m_windowCloseCallback;
};

// To be defined in CLIENT
Application* CreateApplication();

} // namespace elv
