#include "Renderer/Renderer.h"
#include "Renderer/Renderer2D.h"

namespace Elven {
UniquePtr<Renderer::SceneData> Renderer::m_sceneData = MakeUniquePtr<Renderer::SceneData>();

void Renderer::Init()
{
    RenderCommand::Init();
    Renderer2D::Init();
    RenderCommand::EnableDepthTesting(true);
}

void Renderer::Shutdown()
{
    RenderCommand::Shutdown();
}

void Renderer::BeginScene(Camera& camera)
{
    m_sceneData->ViewProjectionMatrix = camera.GetViewProjectionMatrix();
}

void Renderer::EndScene()
{
}

void Renderer::Submit(const SharedPtr<Shader>& shader, const SharedPtr<VertexArray>& vertexArray, const lia::mat4& modelMatrix)
{
    shader->Bind();
    shader->SetMatrix4("u_ViewProjection", m_sceneData->ViewProjectionMatrix);
    shader->SetMatrix4("u_Model", modelMatrix);

    RenderCommand::DrawIndexed(vertexArray);
}

void Renderer::OnWindowResize(std::uint32_t width, std::uint32_t height)
{
    RenderCommand::SetViewport(0, 0, width, height);
}
} // namespace Elven
