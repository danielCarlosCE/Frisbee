final class EncodableAdapterFactory {

    static func make() -> EncodableAdapter {
        return EncoderJSONAdapter()
    }

}
