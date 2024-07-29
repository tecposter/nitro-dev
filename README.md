# AWS

```shell
docker exec -w /home/zjh/aws-nitro-enclaves-cli nitro-local ls
docker exec -w /home/zjh/aws-nitro-enclaves-cli nitro-local cargo run
```


# Errors

## spurious network error (...): [35] SSL connect error

```shell
# RUN curl --proto -sSf https://sh.rustup.rs | bash -s -- -y

❯ docker exec -w /nitro/aws-nitro-enclaves-cli nitro-local cargo build
    Updating crates.io index
warning: spurious network error (3 tries remaining): [35] SSL connect error (Recv failure: Connection reset by peer)
warning: spurious network error (2 tries remaining): [35] SSL connect error (Recv failure: Connection reset by peer)
warning: spurious network error (1 tries remaining): [35] SSL connect error (Recv failure: Connection reset by peer)
error: failed to get `chrono` as a dependency of package `nitro-cli v1.3.2 (/nitro/aws-nitro-enclaves-cli)`
```

Solution rm `--proto '=https' --tlsv1.2`
Old
```shell
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
```

New
```shell
RUN curl -sSf https://sh.rustup.rs | bash -s -- -y
```


```shell
docker exec -u zjh \
  -e PATH="$HOME/.cargo/bin:$PATH" \
  -w /home/zjh/aws-nitro-enclaves-cli \
  nitro-local cargo --version
docker exec -u zjh \
  -w /home/zjh/aws-nitro-enclaves-cli \
  nitro-local cargo --version
```

measure-enclave
```shell
docker exec -u zjh  -w /home/zjh/aws-nitro-enclaves-cli nitro-local cargo run -- measure-enclave --docker-uri hello:latest

Start generating the Enclave Measurements...
Using the locally available Docker image...
{
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "800df8e36aacb4e656f93c26c93b5a1adcd499773d25abb75fc723bb2e12304d10d14350beaa79c6084e0dae8d1f2a6a",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "28eff6bcb841e3df8391c3f4b7fafdb0918e82acf164634577a0edc19fd8c1ad5bf85e0356688666e54af1a2525a728d"
  }
}
```

sign-pcr0

```shell
docker exec -u zjh  -w /home/zjh/aws-nitro-enclaves-cli nitro-local cargo run -- sign-pcr0 \
  --pcr0 800df8e36aacb4e656f93c26c93b5a1adcd499773d25abb75fc723bb2e12304d10d14350beaa79c6084e0dae8d1f2a6a \
  --private-key key_name.pem \
  --output-file measurement.sig
```

build-enclave by signature
```shell
docker exec -u zjh -w /home/zjh/aws-nitro-enclaves-cli nitro-local cargo run -- build-enclave --docker-uri hello:latest --output-file hello.sig.eif --signature measurement.sig --signing-certificate certificate.pem

Enclave Image successfully created.
{
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "800df8e36aacb4e656f93c26c93b5a1adcd499773d25abb75fc723bb2e12304d10d14350beaa79c6084e0dae8d1f2a6a",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "28eff6bcb841e3df8391c3f4b7fafdb0918e82acf164634577a0edc19fd8c1ad5bf85e0356688666e54af1a2525a728d",
    "PCR8": "7ac57169c2059a68a244abfb09e0c2b41c48e517202ee37faa85f14eb0b238ac18605ea3efb47e6f077547300eec1d23"
  }
}
```

build-enclave by private key
```shell
docker exec -u zjh -w /home/zjh/aws-nitro-enclaves-cli nitro-local cargo run -- build-enclave --docker-uri hello:latest --output-file hello.sig.eif --signing-certificate certificate.pem --private-key key_name.pem


tart building the Enclave Image...
Using the locally available Docker image...
Enclave Image successfully created.
{
  "Measurements": {
    "HashAlgorithm": "Sha384 { ... }",
    "PCR0": "800df8e36aacb4e656f93c26c93b5a1adcd499773d25abb75fc723bb2e12304d10d14350beaa79c6084e0dae8d1f2a6a",
    "PCR1": "0343b056cd8485ca7890ddd833476d78460aed2aa161548e4e26bedf321726696257d623e8805f3f605946b3d8b0c6aa",
    "PCR2": "28eff6bcb841e3df8391c3f4b7fafdb0918e82acf164634577a0edc19fd8c1ad5bf85e0356688666e54af1a2525a728d",
    "PCR8": "7ac57169c2059a68a244abfb09e0c2b41c48e517202ee37faa85f14eb0b238ac18605ea3efb47e6f077547300eec1d23"
  }
}
```
