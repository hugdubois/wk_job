import { render, act } from "@testing-library/react"
import LiveHiringProcessPipeline from "./LiveHiringProcessPipeline"

test("renders a live hiring process pipeline display a spinner then display HiringProcessPipeline when timeout reached", () => {
  jest.useFakeTimers()
  const jobId = "my-id"
  const { container } = render(<LiveHiringProcessPipeline jobId={jobId} />)

  expect(container.querySelector(".spinner")).not.toBe(null)

  act(() => {
    jest.runAllTimers()
  })

  expect(container.querySelector(".spinner")).toBe(null)
  expect(container.querySelector(".hiring-process-pipeline")).not.toBe(null)
  // TODO more tests?
})
