
package us.kbase.cmonkey;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: CmonkeyMotif</p>
 * <pre>
 * Represents motif generated by cMonkey with a list of hits in upstream sequences
 * string CmonkeyMotifId - identifier of MotifCmonkey
 * string seqType - type of sequence
 * int pssm_id - number of motif
 * float evalue - motif e-value
 * list<PssmRow> pssm - PSSM 
 * list<HitMast> hits - hits (motif annotations)
 * list<SiteMeme> sites - training set
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "id",
    "seq_type",
    "pssm_id",
    "evalue",
    "pssm_rows",
    "hits",
    "sites"
})
public class CmonkeyMotif {

    @JsonProperty("id")
    private String id;
    @JsonProperty("seq_type")
    private String seqType;
    @JsonProperty("pssm_id")
    private Long pssmId;
    @JsonProperty("evalue")
    private java.lang.Double evalue;
    @JsonProperty("pssm_rows")
    private List<List<Double>> pssmRows;
    @JsonProperty("hits")
    private List<MastHit> hits;
    @JsonProperty("sites")
    private List<SiteMeme> sites;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("id")
    public String getId() {
        return id;
    }

    @JsonProperty("id")
    public void setId(String id) {
        this.id = id;
    }

    public CmonkeyMotif withId(String id) {
        this.id = id;
        return this;
    }

    @JsonProperty("seq_type")
    public String getSeqType() {
        return seqType;
    }

    @JsonProperty("seq_type")
    public void setSeqType(String seqType) {
        this.seqType = seqType;
    }

    public CmonkeyMotif withSeqType(String seqType) {
        this.seqType = seqType;
        return this;
    }

    @JsonProperty("pssm_id")
    public Long getPssmId() {
        return pssmId;
    }

    @JsonProperty("pssm_id")
    public void setPssmId(Long pssmId) {
        this.pssmId = pssmId;
    }

    public CmonkeyMotif withPssmId(Long pssmId) {
        this.pssmId = pssmId;
        return this;
    }

    @JsonProperty("evalue")
    public java.lang.Double getEvalue() {
        return evalue;
    }

    @JsonProperty("evalue")
    public void setEvalue(java.lang.Double evalue) {
        this.evalue = evalue;
    }

    public CmonkeyMotif withEvalue(java.lang.Double evalue) {
        this.evalue = evalue;
        return this;
    }

    @JsonProperty("pssm_rows")
    public List<List<Double>> getPssmRows() {
        return pssmRows;
    }

    @JsonProperty("pssm_rows")
    public void setPssmRows(List<List<Double>> pssmRows) {
        this.pssmRows = pssmRows;
    }

    public CmonkeyMotif withPssmRows(List<List<Double>> pssmRows) {
        this.pssmRows = pssmRows;
        return this;
    }

    @JsonProperty("hits")
    public List<MastHit> getHits() {
        return hits;
    }

    @JsonProperty("hits")
    public void setHits(List<MastHit> hits) {
        this.hits = hits;
    }

    public CmonkeyMotif withHits(List<MastHit> hits) {
        this.hits = hits;
        return this;
    }

    @JsonProperty("sites")
    public List<SiteMeme> getSites() {
        return sites;
    }

    @JsonProperty("sites")
    public void setSites(List<SiteMeme> sites) {
        this.sites = sites;
    }

    public CmonkeyMotif withSites(List<SiteMeme> sites) {
        this.sites = sites;
        return this;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        return ((((((((((((((((("CmonkeyMotif"+" [id=")+ id)+", seqType=")+ seqType)+", pssmId=")+ pssmId)+", evalue=")+ evalue)+", pssmRows=")+ pssmRows)+", hits=")+ hits)+", sites=")+ sites)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
