import ReactDOM from "react-dom"
import { act } from "@testing-library/react"
import Job from "./Job"
import "regenerator-runtime/runtime"

let resolve
global.fetch = () => {
  return new Promise((r) => {
    resolve = r
  })
}

test("renders a job", async () => {
  const job = {
    id: "my-id",
    title: "my title",
  }

  const container = document.createElement("div")
  act(() => {
    ReactDOM.render(<Job id={job.id} title={job.title} />, container)
  })

  expect(container.querySelector(".spinner")).not.toBe(null)

  expect(
    container.querySelector(".hiring-process-pipeline .title")
  ).toHaveTextContent(/my title/i)

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
  expect(container.querySelector(".hiring-process-pipeline")).not.toBe(null)
})
