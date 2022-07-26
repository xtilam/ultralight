import React, { useState } from 'react';
import { Button, Col, Container, FormGroup, Input, Label, Progress, Row, Table } from 'reactstrap';
import { startDownload } from './au3/au3.download';
import { AppResizeBar } from './components/AppResizeBar';
import './sass/App.scss';

function App() {
  const [downloadUrl, setDownloadURL] = useState('https://raw.githubusercontent.com/xtilam/ultralight-lib-au3/master/au3-lib.zip')
  const [savePath, setSavePath] = useState('./au3-lib.zip')
  const [isStartDownload, setStartDownload] = useState(false)
  const [sizeData, setSizeData] = useState([0, 0])

  return (
    <div>
      <AppResizeBar />
      <div id="App">
        <div className='body'>
          <Button color='success' onClick={() => {
            const result = au3('getList')
            console.log(result)
          }}>ProcessList</Button>
          <Container fluid>
            {
              isStartDownload
                ? <>
                  <Row>
                    <Col sm={12}>
                      <Table>
                        <tbody>
                          <tr>
                            <td>URL: </td>
                            <td>{downloadUrl}</td>
                          </tr>
                          <tr>
                            <td>path: </td>
                            <td>{savePath}</td>
                          </tr>
                          <tr>
                            <td>Size: </td>
                            <td>{`${sizeData[1]} --- ${sizeData[0]}`}</td>
                          </tr>
                        </tbody>
                      </Table>
                    </Col>
                    <Col sm={12}>
                      <Progress value={sizeData[0] === 0 ? 0 : Math.floor((sizeData[0] / sizeData[1]) * 100)}></Progress>
                    </Col>
                  </Row>
                  <Row className="mt-2">
                    <Col>
                      <Button color='danger' onClick={() => {

                      }}>Stop</Button>
                    </Col>
                  </Row>
                </>
                : <>
                  <Row>
                    <FormGroup>
                      <Label>URL</Label>
                      <Input value={downloadUrl} onChange={(evt) => setDownloadURL(evt.target.value)}></Input>
                    </FormGroup>
                    <FormGroup>
                      <Label>PathSave</Label>
                      <Input value={savePath} onChange={(evt) => setSavePath(evt.target.value)}></Input>
                    </FormGroup>
                  </Row>
                  <Row>
                    <Col>
                      <Button onClick={async () => {
                        setSizeData([0, 1])
                        setStartDownload(true)
                        
                        await startDownload(downloadUrl, savePath, (total, current, path) => {
                          setSavePath(path)
                          setSizeData([current, total])
                        })

                        setStartDownload(false)
                      }}>Download</Button>

                    </Col>
                  </Row>
                </>
            }
          </Container>
        </div>
      </div>
    </div>
  );
}

export default App;
