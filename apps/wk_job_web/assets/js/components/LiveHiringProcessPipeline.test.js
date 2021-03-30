import ReactDOM from "react-dom"
import { act } from "@testing-library/react"
import LiveHiringProcessPipeline from "./LiveHiringProcessPipeline"
import "regenerator-runtime/runtime"

/*
TODO to prevent the console warning message bellow :

    console.warn
      useChannel broadcast function cannot be invoked before the channel has been joined

      70 |
      71 | const mustJoinChannelWarning = () => () =>
    > 72 |   console.warn(
         |           ^
      73 |     "useChannel broadcast function cannot be invoked before the channel has been joined"
      74 |   )
      75 |

      at broadcast (js/hooks/useChannel.js:72:11)
      at broadcastAndUpdate (js/components/LiveHiringProcessPipeline.js:37:5)

We need to mock phoenix socket or ./component/SocketProvider

But I don't known how to do that :'(. I would need more time to do it.

Here suggest some paths to follow :
  - https://jestjs.io/docs/es6-class-mocks
  - https://github.com/thawkin3/jest-module-mocking-demo/tree/master/src/03_defaultAndNamedExports
  - https://www.emgoto.com/mocking-with-jest/
  - https://rodgobbi.com/mock-module-jest/
  - https://stackoverflow.com/questions/42867183/mocking-websocket-in-jest
  - https://stackoverflow.com/questions/37023797/phoenix-framework-how-to-mock-socket-in-js

For information : phoenix socket definition is here ../../../../../deps/phoenix/assets/js/phoenix.js

        ....

        import { Socket } from "phoenix"
        jest.mock("phoenix")

        ....
          beforeAll(() => {
            Socket.mockImplementation(() => {
              console.log("Call Mock constructor")
            })
          })
        ....
*/

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
    expect(container.querySelector(".hiring-process-pipeline")).not.toBe(null)
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
