module Mutation.RevokeInvitationTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Data.ValidationError exposing (ValidationError)
import Mutation.RevokeInvitation as RevokeInvitation
import Json.Decode exposing (decodeString)
import Json.Encode as Encode


query : Test
query =
    describe "query"
        [ describe "Mutation.RevokeInvitation.variables"
            [ test "assembles variables from params" <|
                \_ ->
                    let
                        params =
                            { id = "999"
                            }

                        encodedResult =
                            RevokeInvitation.variables params

                        expected =
                            Encode.object
                                [ ( "id", Encode.string params.id )
                                ]
                    in
                        Expect.equal expected encodedResult
            ]
        ]


decoders : Test
decoders =
    describe "decoders"
        [ describe "Mutation.RevokeInvitation.decoder"
            [ test "handles success response" <|
                \_ ->
                    let
                        json =
                            """
                              {
                                "data": {
                                  "revokeInvitation": {
                                    "success": true,
                                    "invitation": {
                                      "id": "9999"
                                    },
                                    "errors": []
                                  }
                                }
                              }
                            """

                        result =
                            decodeString RevokeInvitation.decoder json
                    in
                        Expect.equal (Ok (RevokeInvitation.Success "9999")) result
            , test "handles validation error response" <|
                \_ ->
                    let
                        json =
                            """
                              {
                                "data": {
                                  "revokeInvitation": {
                                    "success": false,
                                    "invitation": null,
                                    "errors": [{
                                      "attribute": "base",
                                      "message": "Invitation not found"
                                    }]
                                  }
                                }
                              }
                            """

                        result =
                            decodeString RevokeInvitation.decoder json

                        expected =
                            RevokeInvitation.Invalid
                                [ ValidationError "base" "Invitation not found"
                                ]
                    in
                        Expect.equal (Ok expected) result
            ]
        ]
