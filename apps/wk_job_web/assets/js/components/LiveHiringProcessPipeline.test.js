import ReactDOM from "react-dom"
import { act } from "@testing-library/react"
import LiveHiringProcessPipeline from "./LiveHiringProcessPipeline"
import "regenerator-runtime/runtime"

let resolve
global.fetch = () => {
  return new Promise((r) => {
    resolve = r
  })
}

describe("renders a LiveHiringProcessPipeline", () => {
  test("display HiringProcessPipeline when fetch data", async () => {
    const jobId = "my-id"
    const container = document.createElement("div")
    act(() => {
      ReactDOM.render(<LiveHiringProcessPipeline jobId={jobId} />, container)
    })

    expect(container.querySelector(".spinner")).not.toBe(null)

    await act(async () => {
      resolve({
        ok: true,
        json: () => {
          return new Promise((r) => {
            r(global.fakeHiringProcessPipelineData)
          })
        },
      })
    })

    expect(container.querySelector(".spinner")).toBe(null)
    expect(container.querySelector(".pipeline")).not.toBe(null)
  })

  test("display ErrorMessage when fetch data fail 404", async () => {
    const jobId = "my-id"
    const container = document.createElement("div")
    act(() => {
      ReactDOM.render(<LiveHiringProcessPipeline jobId={jobId} />, container)
    })

    expect(container.querySelector(".spinner")).not.toBe(null)

    await act(async () => {
      resolve({
        ok: false,
        status: 404,
      })
    })

    expect(container.querySelector(".spinner")).toBe(null)
    expect(container.querySelector(".error-message")).not.toBe(null)
    expect(container.querySelector(".error-message h4").innerHTML).toBe(
      "Error 404 - Not Found"
    )
  })

  test("display ErrorMessage when fetch data fail 500", async () => {
    const jobId = "my-id"
    const container = document.createElement("div")
    act(() => {
      ReactDOM.render(<LiveHiringProcessPipeline jobId={jobId} />, container)
    })

    expect(container.querySelector(".spinner")).not.toBe(null)

    await act(async () => {
      resolve({
        ok: false,
        status: 500,
      })
    })

    expect(container.querySelector(".spinner")).toBe(null)
    expect(container.querySelector(".error-message")).not.toBe(null)
    expect(container.querySelector(".error-message h4").innerHTML).toBe(
      "Error 500 - Server Error"
    )
  })
})
