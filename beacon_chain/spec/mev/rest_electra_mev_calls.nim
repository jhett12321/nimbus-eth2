# beacon_chain
# Copyright (c) 2024 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.push raises: [].}

import
  chronos, presto/client,
  ".."/eth2_apis/[rest_types, eth2_rest_serialization]

export chronos, client, rest_types, eth2_rest_serialization

proc getHeaderElectra*(slot: Slot,
                     parent_hash: Eth2Digest,
                     pubkey: ValidatorPubKey
                    ): RestPlainResponse {.
     rest, endpoint: "/eth/v1/builder/header/{slot}/{parent_hash}/{pubkey}",
     meth: MethodGet, connection: {Dedicated, Close}.}
  ## https://github.com/ethereum/builder-specs/blob/v0.4.0/apis/builder/header.yaml

proc submitBlindedBlockPlain*(
    body: electra_mev.SignedBlindedBeaconBlock
): RestPlainResponse {.
   rest, endpoint: "/eth/v1/builder/blinded_blocks",
   meth: MethodPost, connection: {Dedicated, Close}.}
  ## https://github.com/ethereum/builder-specs/blob/v0.4.0/apis/builder/blinded_blocks.yaml

proc submitBlindedBlock*(
  client: RestClientRef,
  body: electra_mev.SignedBlindedBeaconBlock
): Future[RestPlainResponse] {.
  async: (raises: [CancelledError, RestEncodingError, RestDnsResolveError,
                   RestCommunicationError]).} =
  ## https://github.com/ethereum/builder-specs/blob/v0.4.0/apis/builder/blinded_blocks.yaml
  await client.submitBlindedBlockPlain(
    body,
    extraHeaders = @[("eth-consensus-version", toString(ConsensusFork.Electra))]
  )