Build and push to local registry:

```
$ wasme build assemblyscript -t localhost:5000/filters/add-header .
$ wasme list
NAME                              TAG    SIZE    SHA      UPDATED
localhost:5000/filters/add-header latest 12.6 kB a515a5d2 29 Jul 22 10:26 BST
$ wasme push localhost:5000/filters/add-header
```

We can poke at the registry and find out about the data:

```json
$ curl -H "Accept: application/vnd.oci.image.manifest.v1+json" localhost:5000/v2/filters/add-header/manifests/latest
{"schemaVersion":2,"config":{"mediaType":"application/vnd.module.wasm.config.v1+json","digest":"sha256:fe494a4546f6e664d679b31926d634df5bb6b3d5d19c0b8063ba80742a615214","size":221,"annotations":{"org.opencontainers.image.title":"runtime-config.json"}},"layers":[{"mediaType":"application/vnd.module.wasm.config.v1+json","digest":"sha256:fe494a4546f6e664d679b31926d634df5bb6b3d5d19c0b8063ba80742a615214","size":221,"annotations":{"org.opencontainers.image.title":"runtime-config.json"}},{"mediaType":"application/vnd.module.wasm.content.layer.v1+wasm","digest":"sha256:28d7053f5e4af9418b07b5ff36234587678983a64c8ee68b804b4da7313bc5f7","size":28936,"annotations":{"org.opencontainers.image.title":"filter.wasm"}}],"annotations":{"module.wasm.runtime/abi_version":"v0-541b2c1155fffb15ccde92b8324f3e38f7339ba6,v0-097b7f2e4cc1fb490cc1943d0d633655ac3c522f,v0-4689a30309abf31aee9ae36e73d34b1bb182685f,v0.2.1","module.wasm.runtime/type":"envoy_proxy"}}
```

and download the WASM from the registry (it's the blob with the `*+wasm` type):

```
$ curl localhost:5000/v2/filters/add-header/blobs/sha256:28d7053f5e4af9418b07b5ff36234587678983a64c8ee68b804b4da7313bc5f7 > blob.wasm
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 28936  100 28936    0     0  1883k      0 --:--:-- --:--:-- --:--:-- 1883k
nix:hello-wasme$ file blob.wasm 
blob.wasm: WebAssembly (wasm) binary module version 0x1 (MVP)
```

the other blob is JSON config:

```json
$ curl localhost:5000/v2/filters/add-header/blobs/sha256:fe494a4546f6e664d679b31926d634df5bb6b3d5d19c0b8063ba80742a615214
{"type":"envoy_proxy","abiVersions":["v0-541b2c1155fffb15ccde92b8324f3e38f7339ba6","v0-097b7f2e4cc1fb490cc1943d0d633655ac3c522f","v0-4689a30309abf31aee9ae36e73d34b1bb182685f","v0.2.1"],"config":{"rootIds":["add_header"]}}
```